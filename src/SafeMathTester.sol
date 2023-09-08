// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SafeMathTester {
    uint8 public bigNumber = 255;

    function add() public {
        // unchecked removes the SafeMath library functionality and allows int overflow/underflow
        // reason to use unchecked is less gas, if you are sure that it will not be an issue in your contract this feature makes it more gas efficient
        unchecked {
            bigNumber = bigNumber + 1;
        }
    }
}
