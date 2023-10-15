/**
 * /-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\
 * |                                     |
 * \ _____    ____                       /
 * -|_   _|  / ___|_      ____ _ _ __    -
 * /  | |____\___ \ \ /\ / / _` | '_ \   \
 * |  | |_____|__) \ V  V / (_| | |_) |  |
 * \  |_|    |____/ \_/\_/ \__,_| .__/   /
 * -                            |_|      -
 * /                                     \
 * |                                     |
 * \-/|\-/|\-/|\-/|\-/|\-/|\-/|\-/|\-/|\-/
 */
// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity 0.8.20;

import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TSwapPool is ERC20 {
    error TSwapPool__DeadlineHasPassed(uint256 deadline);
    error TSwapPool__MaxPoolTokenDepositTooHigh(uint256 maximumPoolTokensToDeposit, uint256 poolTokensToDeposit);
    error TSwapPool__MinLiquidityTokensToMintTooLow(uint256 minimumLiquidityTokensToMint, uint256 liquidityTokensToMint);
    error TSwapPool__WethDepositAmountTooLow(uint256 minimumWethDeposit, uint256 wethToDeposit);
    error TSwapPool__WethToReceiveTooLow(uint256 minWethToWithdraw);
    error TSwapPool__PoolTokensToReceiveTooLow(uint256 minPoolTokensToWithdraw);
    error TSwapPool__WethTokensToSendTooHigh(uint256 wethToSend, uint256 maxWeth);
    error TSwapPool__MustBeMoreThanZero();

    using SafeERC20 for IERC20;

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    IERC20 public constant WETH_TOKEN = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 private immutable i_poolToken;
    uint256 private constant MINIMUM_WETH_LIQUIDITY = 1_000_000_000;
    uint256 private constant FEE = 3;
    uint256 private constant FEE_DENOMINATOR = 1000;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event LiquidityAdded(address indexed liquidityProvider, uint256 wethDeposited, uint256 poolTokensDeposited);
    event LiquidityRemoved(address indexed liquidityProvider, uint256 wethWithdrawn, uint256 poolTokensWithdrawn);
    event WethSwappedForPoolToken(address indexed swapper, uint256 wethSold, uint256 poolTokensReceived);
    event PoolTokenSwappedForWeth(address indexed swapper, uint256 poolTokenSold, uint256 wethReceived);

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier revertIfDeadlinePassed(uint256 deadline) {
        if (deadline < block.timestamp) {
            revert TSwapPool__DeadlineHasPassed(deadline);
        }
        _;
    }

    modifier revertIfZero(uint256 amount) {
        if (amount == 0) {
            revert TSwapPool__MustBeMoreThanZero();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(
        address poolToken,
        string memory liquidityTokenName,
        string memory liquidityTokenSymbol
    )
        ERC20(liquidityTokenName, liquidityTokenSymbol)
    {
        i_poolToken = IERC20(poolToken);
    }

    /*//////////////////////////////////////////////////////////////
                        ADD AND REMOVE LIQUIDITY
    //////////////////////////////////////////////////////////////*/

    /// @notice Adds liquidity to the pool
    /// @dev The invariant of this function is that the ratio of WETH, PoolTokens, and LiquidityTokens is the same
    /// before and after the transaction
    /// @param wethToDeposit Amount of WETH the user is going to deposit
    /// @param minimumLiquidityTokensToMint We derive the amount of liquidity tokens to mint from the amount of WETH the
    /// user is going to deposit, but set a minimum so they know approx what they will accept
    /// @param maximumPoolTokensToDeposit The maximum amount of pool tokens the user is willing to deposit, again it's
    /// derived from the amount of WETH the user is going to deposit
    /// @param deadline The deadline for the transaction to be completed by
    function deposit(
        uint256 wethToDeposit,
        uint256 minimumLiquidityTokensToMint,
        uint256 maximumPoolTokensToDeposit,
        uint256 deadline
    )
        external
        revertIfDeadlinePassed(deadline)
        revertIfZero(wethToDeposit)
        returns (uint256 liquidityTokensToMint)
    {
        if (wethToDeposit < MINIMUM_WETH_LIQUIDITY) {
            revert TSwapPool__WethDepositAmountTooLow(MINIMUM_WETH_LIQUIDITY, wethToDeposit);
        }
        if (totalSupply() > 0) {
            uint256 currentWethDeposited = WETH_TOKEN.balanceOf(address(this));
            uint256 currentPoolTokensDeposited = i_poolToken.balanceOf(address(this));
            // Our invariant says weth, poolTokens, and liquidity tokens must always have the same ratio after the
            // initial deposit
            // poolTokens / constant(k) = weth
            // weth / constant(k) = liquidityTokens
            // aka...
            // weth / poolTokens = constant(k)
            // To make sure this holds, we can make sure the new balance will match the old balance
            // (currentWethDeposited + wethToDeposit) / (currentPoolTokensDeposited + poolTokensToDeposit) = constant(k)
            // (currentWethDeposited + wethToDeposit) / (currentPoolTokensDeposited + poolTokensToDeposit) =
            // (currentWethDeposited / currentPoolTokensDeposited)
            //
            // So we can do some elementary math now to figure out poolTokensToDeposit...
            // (currentWethDeposited + wethToDeposit) / poolTokensToDeposit = currentWethDeposited
            // (currentWethDeposited + wethToDeposit)  = currentWethDeposited * poolTokensToDeposit
            // (currentWethDeposited + wethToDeposit) / currentWethDeposited  =  poolTokensToDeposit
            uint256 poolTokensToDeposit = wethToDeposit * currentPoolTokensDeposited / currentWethDeposited;
            if (maximumPoolTokensToDeposit < poolTokensToDeposit) {
                revert TSwapPool__MaxPoolTokenDepositTooHigh(maximumPoolTokensToDeposit, poolTokensToDeposit);
            }

            // We do the same thing for liquidity tokens. Similar math.
            liquidityTokensToMint = wethToDeposit * totalLiquidityTokenSupply() / currentWethDeposited;
            if (liquidityTokensToMint < minimumLiquidityTokensToMint) {
                revert TSwapPool__MinLiquidityTokensToMintTooLow(minimumLiquidityTokensToMint, liquidityTokensToMint);
            }
            _addLiquidityMintAndTransfer(wethToDeposit, poolTokensToDeposit, liquidityTokensToMint);
        } else {
            // This will be the "initial" funding of the protocol. We are starting from blank here!
            // We just have them send the tokens in, and we mint liquidity tokens based on the weth
            _addLiquidityMintAndTransfer(wethToDeposit, maximumPoolTokensToDeposit, wethToDeposit);
            liquidityTokensToMint = wethToDeposit;
        }
    }

    /// @dev This is a sensitive function, and should only be called by addLiquidity
    /// @param wethToDeposit The amount of WETH the user is going to deposit
    /// @param poolTokensToDeposit The amount of pool tokens the user is going to deposit
    /// @param liquidityTokensToMint The amount of liquidity tokens the user is going to mint
    function _addLiquidityMintAndTransfer(
        uint256 wethToDeposit,
        uint256 poolTokensToDeposit,
        uint256 liquidityTokensToMint
    )
        private
    {
        _mint(msg.sender, liquidityTokensToMint);
        emit LiquidityAdded(msg.sender, wethToDeposit, poolTokensToDeposit);

        // Interactions
        WETH_TOKEN.safeTransferFrom(msg.sender, address(this), wethToDeposit);
        i_poolToken.safeTransferFrom(msg.sender, address(this), poolTokensToDeposit);
    }

    /// @notice Removes liquidity from the pool
    /// @param liquidityTokensToBurn The number of liquidity tokens the user wants to burn
    /// @param minWethToWithdraw The minimum amount of WETH the user wants to withdraw
    /// @param minPoolTokensToWithdraw The minimum amount of pool tokens the user wants to withdraw
    /// @param deadline The deadline for the transaction to be completed by
    function withdraw(
        uint256 liquidityTokensToBurn,
        uint256 minWethToWithdraw,
        uint256 minPoolTokensToWithdraw,
        uint256 deadline
    )
        external
        revertIfDeadlinePassed(deadline)
        revertIfZero(liquidityTokensToBurn)
        revertIfZero(minWethToWithdraw)
        revertIfZero(minPoolTokensToWithdraw)
    {
        // We do the same math as above
        uint256 wethToWithdraw =
            liquidityTokensToBurn * WETH_TOKEN.balanceOf(address(this)) / totalLiquidityTokenSupply();
        uint256 poolTokensToWithdraw =
            liquidityTokensToBurn * i_poolToken.balanceOf(address(this)) / totalLiquidityTokenSupply();

        if (wethToWithdraw < minWethToWithdraw) {
            revert TSwapPool__WethToReceiveTooLow(minWethToWithdraw);
        }
        if (poolTokensToWithdraw < minPoolTokensToWithdraw) {
            revert TSwapPool__PoolTokensToReceiveTooLow(minPoolTokensToWithdraw);
        }
        _burn(msg.sender, liquidityTokensToBurn);
        emit LiquidityRemoved(msg.sender, wethToWithdraw, poolTokensToWithdraw);

        WETH_TOKEN.safeTransfer(msg.sender, wethToWithdraw);
        i_poolToken.safeTransfer(msg.sender, poolTokensToWithdraw);
    }

    /*//////////////////////////////////////////////////////////////
                              GET PRICING
    //////////////////////////////////////////////////////////////*/

    function getOutputAmountBasedOnInput(
        uint256 inputTokensOrWeth,
        uint256 inputTokensOrWethReserves,
        uint256 outputTokensOrWethReserves
    )
        public
        pure
        revertIfZero(inputTokensOrWeth)
        revertIfZero(outputTokensOrWethReserves)
        returns (uint256 outputTokensOrWeth)
    {
        // x * y = k
        // numberOfWeth * numberOfPoolTokens = constant k
        // k must not change during a transaction (invariant)
        // with this math, we want to figure out how many PoolTokens to deposit
        // since weth * poolTokens = k, we can rearrange to get:
        // (currentWeth + wethToDeposit) * (currentPoolTokens + poolTokensToDeposit) = k
        // **************************
        // ****** MATH TIME!!! ******
        // **************************
        // FOIL it (or ChatGPT): https://en.wikipedia.org/wiki/FOIL_method
        // (totalWethOfPool * totalPoolTokensOfPool) + (totalWethOfPool * poolTokensToDeposit) + (wethToDeposit *
        // totalPoolTokensOfPool) + (wethToDeposit * poolTokensToDeposit) = k
        // (totalWethOfPool * totalPoolTokensOfPool) + (wethToDeposit * totalPoolTokensOfPool) = k - (totalWethOfPool *
        // poolTokensToDeposit) - (wethToDeposit * poolTokensToDeposit)
        uint256 inputAmountMinusFee = inputTokensOrWeth * (FEE_DENOMINATOR - FEE);
        uint256 numerator = inputAmountMinusFee * outputTokensOrWethReserves;
        uint256 denominator = (inputTokensOrWethReserves * FEE_DENOMINATOR) + inputAmountMinusFee;
        return numerator / denominator;
    }

    function getInputAmountBasedOnOutput(
        uint256 outputTokensOrWeth,
        uint256 inputTokensOrWethReserves,
        uint256 outputTokensOrWethReserves
    )
        public
        pure
        revertIfZero(outputTokensOrWeth)
        revertIfZero(outputTokensOrWethReserves)
        returns (uint256 inputTokensOrWeth)
    {
        uint256 numerator = inputTokensOrWethReserves * outputTokensOrWeth * FEE_DENOMINATOR;
        uint256 denominator = (outputTokensOrWethReserves - outputTokensOrWeth) * (FEE_DENOMINATOR - FEE);
        return numerator / denominator;
    }

    /*//////////////////////////////////////////////////////////////
                       SWAP WETH FOR POOL TOKENS
    //////////////////////////////////////////////////////////////*/

    function _swapWethForPoolToken(uint256 wethAmount, uint256 poolTokenAmount) private {
        emit WethSwappedForPoolToken(msg.sender, wethAmount, poolTokenAmount);
        WETH_TOKEN.safeTransferFrom(msg.sender, address(this), wethAmount);
        i_poolToken.safeTransfer(msg.sender, poolTokenAmount);
    }

    function swapWethForPoolTokenBasedOnInputWeth(
        uint256 wethAmount,
        uint256 minTokenAmount,
        uint256 deadline
    )
        external
        revertIfDeadlinePassed(deadline)
        revertIfZero(minTokenAmount)
        revertIfZero(wethAmount)
        returns (uint256 poolTokensBought)
    {
        poolTokensBought = getOutputAmountBasedOnInput(
            wethAmount, WETH_TOKEN.balanceOf(address(this)), i_poolToken.balanceOf(address(this))
        );
        if (poolTokensBought < minTokenAmount) {
            revert TSwapPool__PoolTokensToReceiveTooLow(minTokenAmount);
        }
        _swapWethForPoolToken(wethAmount, poolTokensBought);
    }

    /// @notice user swaps weth -> pool tokens based on a specific amount of pool tokens they want to receive
    /// @param poolTokenAmount Exact number of pool tokens to buy
    /// @param maxWeth Max number of Weth to sell for the pool tokens
    /// @param deadline The timestamp when this transaction must be completed by
    function swapWethForPoolTokenBasedOnOutputPoolToken(
        uint256 poolTokenAmount,
        uint256 maxWeth,
        uint256 deadline
    )
        external
        revertIfDeadlinePassed(deadline)
        revertIfZero(maxWeth)
        revertIfZero(poolTokenAmount)
        returns (uint256 wethSold)
    {
        wethSold = getInputAmountBasedOnOutput(
            poolTokenAmount, i_poolToken.balanceOf(address(this)), WETH_TOKEN.balanceOf(address(this))
        );
        if (wethSold > maxWeth) {
            revert TSwapPool__WethTokensToSendTooHigh(wethSold, maxWeth);
        }
        _swapWethForPoolToken(wethSold, poolTokenAmount);
    }

    /*//////////////////////////////////////////////////////////////
                       SWAP POOL TOKENS FOR WETH
    //////////////////////////////////////////////////////////////*/

    function _swapPoolTokensForWeth(uint256 poolTokenAmount, uint256 wethAmount) private {
        emit PoolTokenSwappedForWeth(msg.sender, wethAmount, poolTokenAmount);
        WETH_TOKEN.safeTransfer(msg.sender, wethAmount);
        i_poolToken.safeTransferFrom(msg.sender, address(this), poolTokenAmount);
    }

    function swapPoolTokenForWethBasedOnInputPoolToken(
        uint256 poolTokenAmount,
        uint256 minWeth,
        uint256 deadline
    )
        external
        revertIfDeadlinePassed(deadline)
        revertIfZero(poolTokenAmount)
        revertIfZero(minWeth)
        returns (uint256 wethBought)
    {
        wethBought = getOutputAmountBasedOnInput(
            poolTokenAmount, i_poolToken.balanceOf(address(this)), WETH_TOKEN.balanceOf(address(this))
        );
        if (wethBought < minWeth) {
            revert TSwapPool__WethToReceiveTooLow(wethBought);
        }
        _swapPoolTokensForWeth(poolTokenAmount, wethBought);
    }

    function swapPoolTokenForWethBasedOnOutputWeth(
        uint256 wethAmount,
        uint256 maxPoolTokens,
        uint256 deadline
    )
        external
        revertIfDeadlinePassed(deadline)
        revertIfZero(wethAmount)
        revertIfZero(maxPoolTokens)
        returns (uint256 poolTokensSold)
    {
        poolTokensSold = getInputAmountBasedOnOutput(
            wethAmount, WETH_TOKEN.balanceOf(address(this)), i_poolToken.balanceOf(address(this))
        );
        if (poolTokensSold > maxPoolTokens) {
            revert TSwapPool__WethToReceiveTooLow(wethAmount);
        }
        _swapPoolTokensForWeth(poolTokensSold, wethAmount);
    }

    /*//////////////////////////////////////////////////////////////
                   EXTERNAL AND PUBLIC VIEW AND PURE
    //////////////////////////////////////////////////////////////*/

    function getFee() external pure returns (uint256) {
        return FEE;
    }

    function getFeeDenominator() external pure returns (uint256) {
        return FEE_DENOMINATOR;
    }

    /// @notice a more verbose way of getting the total supply of liquidity tokens
    function totalLiquidityTokenSupply() public view returns (uint256) {
        return totalSupply();
    }

    function getToken() external view returns (address) {
        return address(i_poolToken);
    }

    function getWeth() external pure returns (address) {
        return address(WETH_TOKEN);
    }

    function getMinimumWethDepositAmount() external pure returns (uint256) {
        return MINIMUM_WETH_LIQUIDITY;
    }

    function getPriceOfOneWethInPoolTokens() external view returns (uint256) {
        return
            getOutputAmountBasedOnInput(1e18, WETH_TOKEN.balanceOf(address(this)), i_poolToken.balanceOf(address(this)));
    }

    function getPriceOfOnePoolTokenInWeth() external view returns (uint256) {
        return
            getOutputAmountBasedOnInput(1e18, i_poolToken.balanceOf(address(this)), WETH_TOKEN.balanceOf(address(this)));
    }
}
