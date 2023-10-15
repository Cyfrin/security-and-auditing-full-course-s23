// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { PoolFactory } from "../../src/PoolFactory.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract PoolFactoryTest is Test {
    PoolFactory factory;
    ERC20Mock tokenA;
    ERC20Mock tokenB;

    function setUp() public {
        factory = new PoolFactory();
        tokenA = new ERC20Mock();
        tokenB = new ERC20Mock();
    }

    function testCreatePool() public {
        address poolAddress = factory.createPool(address(tokenA));
        assertEq(poolAddress, factory.getPool(address(tokenA)));
        assertEq(address(tokenA), factory.getToken(poolAddress));
    }

    function testCantCreatePoolIfExists() public {
        factory.createPool(address(tokenA));
        vm.expectRevert(abi.encodeWithSelector(PoolFactory.PoolFactory__PoolAlreadyExists.selector, address(tokenA)));
        factory.createPool(address(tokenA));
    }
}
