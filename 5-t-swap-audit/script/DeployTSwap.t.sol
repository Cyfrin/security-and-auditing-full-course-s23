// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Script } from "forge-std/Script.sol";
import { PoolFactory } from "../src/PoolFactory.sol";
import { TSwapPool } from "../src/TSwapPool.sol";

contract DeployTSwap is Script {
    function run() public {
        vm.startBroadcast();
        new PoolFactory();
        vm.stopBroadcast();
    }
}
