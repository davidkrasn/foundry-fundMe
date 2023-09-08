// SPDX-License-Identifier: MIT

// Funsd script
// Withdraw script

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    // Does not have dev ops
    function fundFundMe() public {
        vm.startBroadcast();
        FundMe(payable).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {}
}
