// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { MockTSwapPool } from "./MockTSwapPool.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";

contract MockPoolFactory {
    error PoolFactory__PoolAlreadyExists(address tokenAddress);
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    mapping(address token => address pool) private s_pools;
    mapping(address pool => address token) private s_tokens;

    function createPool(address tokenAddress) external returns (address) {
        if (s_pools[tokenAddress] != address(0)) {
            revert PoolFactory__PoolAlreadyExists(tokenAddress);
        }
        MockTSwapPool tPool = new MockTSwapPool();
        s_pools[tokenAddress] = address(tPool);
        s_tokens[address(tPool)] = tokenAddress;
        return address(tPool);
    }

    function getPool(address tokenAddress) external view returns (address) {
        return s_pools[tokenAddress];
    }
}
