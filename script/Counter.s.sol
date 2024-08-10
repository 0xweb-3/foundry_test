// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    Counter public counter;

    function setUp() pure public {
        console2.log("run setUp");
    }

    function run() public {
        vm.startBroadcast();

        counter = new Counter();

        vm.stopBroadcast();
    }

    // forge script script/Counter.s.sol --sig="run1" # 没有参数时
    // foundry_test % forge script script/Counter.s.sol --sig="run1(uint256)" 100
    function run1(uint256 x) pure public {
        console2.log("run run1", x);
    }
}
