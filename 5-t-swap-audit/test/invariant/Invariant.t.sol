// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, StdInvariant, console } from "forge-std/Test.sol";
import { PoolFactory } from "../../src/PoolFactory.sol";
import { TSwapPool } from "../../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { TSwapPoolHandler } from "./handlers/TSwapPoolHandler.sol";

contract Invariant is StdInvariant, Test {
    PoolFactory factory;
    TSwapPool pool;
    ERC20Mock tokenA;
    ERC20Mock WETH;
    ERC20Mock tokenB;

    TSwapPoolHandler handler;

    function setUp() public {
        factory = new PoolFactory();
        tokenA = new ERC20Mock();
        pool = TSwapPool(factory.createPool(address(tokenA)));

        // Overright the WETH address
        deployCodeTo("ERC20Mock.sol:ERC20Mock", address(pool.WETH_TOKEN()));

        handler = new TSwapPoolHandler(pool);

        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = TSwapPoolHandler.deposit.selector;
        selectors[1] = TSwapPoolHandler.swapPoolTokenForWethBasedOnOutputWeth.selector;

        targetSelector(FuzzSelector({ addr: address(handler), selectors: selectors }));
        targetContract(address(handler));
    }

    // Normal Invariant
    // x * y = (x + ∆x) * (y − ∆y)
    // x = Token Balance X
    // ∆x = Change of token balance X
    // β = (∆y / y)
    // α = (∆x / x)
    // Final invariant equation:
    // ∆x = (β/(1-β)) * x
    // ∆y = (α/(1+α)) * y

    // Invariant with fees
    // ρ = fee (between 0 & 1, aka a percentage)
    // γ = (1 - p) (pronounced gamma)
    // ∆x = (β/(1-β)) * (1/γ) * x
    // ∆y = (αγ/1+αγ) * y
    function invariant_testConstantProduct() public {
        assertEq(handler.deltaX(), 0);
    }
}
