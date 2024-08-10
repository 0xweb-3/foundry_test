// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract CounterTest is Test {
    Counter public counter;
    address public selfAddress;
    Helper public helper;
    IERC20 public pepe; 

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);

        helper =new Helper();

        selfAddress = address(1);

        pepe = IERC20(0x6982508145454Ce325dDbE47a25d4ec3d2311933);
        // 如果环境变量已经设置情况下可读取
        // dai = IERC20(vm.envAddress("DAI"));
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
    function test_event1() public{
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

    
    function test_change() public {
        // 改变账户中代币的数量
        console2.log(selfAddress.balance);
        vm.deal(selfAddress, 1 ether);
        console2.log("new balance", selfAddress.balance);

        string memory rpcUrl = vm.envString("ETH_RPC_URL");
        uint256 mainNetForkId = vm.createFork(rpcUrl);
        vm.selectFork(mainNetForkId);
        console2.log("forkId", mainNetForkId);
        // forge test -vvv --fork-url=$ETH_RPC_URL 需要虚拟化运行主网
        console2.log("pepe before", pepe.balanceOf(selfAddress));
        deal(address(pepe), selfAddress, 10244000000);
        console2.log("pepe after", pepe.balanceOf(selfAddress));
    }

    // 设置运行的环境
    function test_runRpc() public {
        string memory rpcUrl = vm.envString("ETH_RPC_URL");
        uint256 mainNetForkId = vm.createFork(rpcUrl);
        vm.selectFork(mainNetForkId);
        // vm.rollFork(10000); //在指定块儿高执行
        // console2.log(block.number);
        console2.log("forkId", mainNetForkId);
        // 后续都在fork环境下执行
    }

    // 对比其他语言的计算结果和sol合约中是否相同
    // forge test -vvv --ffi
    function test_checkSign() public{
        string memory message = "xin";
        bytes32 hashInfo = keccak256(abi.encodePacked(message));
        console2.logBytes32(hashInfo);

        string[] memory cmd = new string[](3);
        cmd[0] = "cast";
        cmd[1] = "keccak";
        cmd[2] = message;

        bytes memory result = vm.ffi(cmd);
        bytes32 hash1 = abi.decode(result, (bytes32));

        assertEq(hashInfo, hash1);
    }

    event MyEvent(uint256 indexed a, uint256 indexed b, uint256 c);

    // 函数事件的捕获
    function test_event() public {
        vm.expectEmit(false, false, false, false);
        emit MyEvent(1, 2, 3);
        helper.callEvent();
    }

    // 自定义错误
    function test_revert()public {
        vm.expectRevert("some revert");
        helper.revertIt();
    }

    function test_CustomError()public {
        vm.expectRevert(Helper.CustomError.selector);
        helper.callCustomError();
    }
}


contract Helper{
    event MyEvent(uint256 indexed a, uint256 indexed b, uint256 c);
    error CustomError();

    function whoCalled() view public returns(address) {
        return msg.sender;
    }

    function callEvent() public {
        emit MyEvent(1, 2, 3);
    }

    function revertIt() public {
        revert("some revert");
    }

    function callCustomError() public {
        revert CustomError(); 
    }
}