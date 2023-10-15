// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "../../../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract TSwapPoolHandler is Test {
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    int256 public deltaX;

    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");
    uint256 DEFAULT_LIQUIDITY_AMOUNT = 10e18;

    constructor(TSwapPool _pool) {
        pool = _pool;
        weth = ERC20Mock(address(pool.getWeth()));
        poolToken = ERC20Mock(address(pool.getPoolToken()));
    }

    // get all methods with
    // forge inspect TSwapPool methods

    // We should have the lower bound be 1
    // upper bound not be too high

    function swapPoolTokenForWethBasedOnOutputWeth(uint256 outputWethAmount) public {
        int256 startingPoolTokenBalance = int256(poolToken.balanceOf(address(pool)));
        int256 startingWethBalance = int256(weth.balanceOf(address(pool)));

        if (weth.balanceOf(address(pool)) <= pool.getMinimumWethDepositAmount()) {
            return;
        }

        outputWethAmount = bound(outputWethAmount, pool.getMinimumWethDepositAmount(), weth.balanceOf(address(pool)));

        uint256 poolTokenAmount = pool.getInputAmountBasedOnOutput(
            outputWethAmount, // outputAmount
            poolToken.balanceOf(address(pool)), // inputReserves
            weth.balanceOf(address(pool)) // outputReserves
        );
        
        // Mint any necessary amount of pool tokens
        if (poolToken.balanceOf(user) < poolTokenAmount) {
            poolToken.mint(user, poolTokenAmount - poolToken.balanceOf(user) + 1);
        }

        vm.startPrank(user);
        // Approve tokens so they can be pulled by the pool during the swap
        poolToken.approve(address(pool), type(uint256).max);

        // Execute swap, giving pool tokens, receiving WETH
        pool.swapExactOutput({
            inputToken: poolToken,
            outputToken: weth,
            outputAmount: outputWethAmount,
            deadline: uint64(block.timestamp)
        });
        vm.stopPrank();

        // Query balances in pool after the swap
        uint256 endingPoolTokenBalance = poolToken.balanceOf(address(pool));
        uint256 endingWethBalance = weth.balanceOf(address(pool));

        // sell tokens == x == poolTokens
        int256 actualDeltaPoolToken = int256(endingPoolTokenBalance) - int256(startingPoolTokenBalance);
        int256 deltaWeth = int256(endingWethBalance) - int256(startingWethBalance);
        int256 one = int256(1000);
        int256 fee = int256(3);

        // Calculate the expected delta of pool tokens
        int256 expectedDeltaPoolToken = (deltaWeth / startingWethBalance) / (one - (deltaWeth / startingWethBalance))
            * (one / (one - fee)) * startingPoolTokenBalance;

        // If everything is working ok, the difference between expected and actual (`deltaX`) should always be 0 
        deltaX = expectedDeltaPoolToken - actualDeltaPoolToken;
    }

    function deposit(uint256 liquidityAmount) public {
        liquidityAmount = bound(liquidityAmount, pool.getMinimumWethDepositAmount(), type(uint64).max);

        vm.startPrank(liquidityProvider);
        if (type(uint64).max < weth.balanceOf(liquidityProvider)) {
            return;
        }
        if (type(uint64).max < poolToken.balanceOf(liquidityProvider)) {
            return;
        }
        uint256 wethTopUpAmount = type(uint64).max - weth.balanceOf(liquidityProvider);
        uint256 poolTokenTopUpAmount = type(uint64).max - poolToken.balanceOf(liquidityProvider);

        weth.mint(liquidityProvider, wethTopUpAmount);
        poolToken.mint(liquidityProvider, poolTokenTopUpAmount);

        weth.approve(address(pool), type(uint256).max);
        poolToken.approve(address(pool), type(uint256).max);

        pool.deposit({
            wethToDeposit: liquidityAmount,
            minimumLiquidityTokensToMint: 0,
            maximumPoolTokensToDeposit: type(uint64).max,
            deadline: uint64(block.timestamp)
        });
        vm.stopPrank();
    }
}
