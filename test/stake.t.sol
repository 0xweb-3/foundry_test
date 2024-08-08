// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StakePool} from "../src/Stake.sol";
import {MockERC20} from "./mocks/MockERC20.sol";

contract StakePoolTest is Test {
    StakePool public stakePool;
    MockERC20 public token;

    function setUp() public {
        stakePool = new StakePool();
        token = new MockERC20(1e8*1e8, "xin", 18, "X");
    }

    function test_stake(uint256 amount) public {
        vm.assume(amount < 1e8*1e8);
        // uint256 amount = 1e18;
        token.approve(address(stakePool), amount);
        bool success = stakePool.stake(address(token), amount);
        assertTrue(success, "stake success");
    }

    // function test_unstake(uint256 x) public {
    //     bool success = stakePool.unstake(address(token));
    //     assertTrue(success);
    // }
}
