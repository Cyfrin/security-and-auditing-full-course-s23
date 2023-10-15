// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IThunderLoan {
    function repay(address token, uint256 amount) external;
}
