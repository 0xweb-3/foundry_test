// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/IERC20.sol";

contract StakePool {
    error stakeFailed();
    error unstakeFailed();
    // amount = deposits[user][token]
    mapping(address=>mapping(address=>uint256)) deposits;


    function stake(address token, uint256 amount) external returns(bool success) {
        success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        if (!success) {
            revert stakeFailed();
        }
        deposits[msg.sender][token] += amount;
        return success;
    }

    function unstake(address token) external returns(bool success) {
        uint256 amount = deposits[msg.sender][token];
        success = IERC20(token).transferFrom(address(this), msg.sender, amount);
        if (!success) {
            revert unstakeFailed();
        }
        deposits[msg.sender][token] = 0;
        return success;
    }
}

