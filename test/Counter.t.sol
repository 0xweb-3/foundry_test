// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address public selfAddress;
    Helper public helper;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);

        helper =new Helper();

        selfAddress = address(1);
    }

    // function test_Increment() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }

    // 使用console2
    function test_console2() pure public {
        console2.log("Testing setValue function with 42");
    }

    // 使用定义好的事件
    function test_event() public{
        emit log("use event ");
        emit log_address(msg.sender);
    }

    // 改变执行的环境
    function test_changeVm() public {
        console2.log("the time:", block.timestamp);
        vm.warp(1000);
        console2.log("the time:", block.timestamp);

        console2.log("the time:", block.number);
        vm.roll(1000);
        console2.log("the time:", block.number);
    }

    // 改变下一个call的msg.sender
    function test_prank() public {
        address caller = helper.whoCalled();
        console2.log("the caller ", caller);
        address addr =  address(this);
        console2.log("CounterTest address", addr);

        vm.prank(selfAddress);

        caller = helper.whoCalled();
        console2.log("the caller ", caller);

        // 系列调用不变
        // vm.startPrank(msgSender);
        // vm.stopPrank();

    }
}


contract Helper{
    function whoCalled() view public returns(address) {
        return msg.sender;
    }
}