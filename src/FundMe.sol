// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

// import  {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {AggregatorV3Interface} from "./PriceConverter.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();
error FundMe__NotSend();
error FundMe__NotCall();
error FundMe__NotEnoughEth();

// get funds from users
// withdraw funds
// set min funding value

contract FundMe {
    using PriceConverter for uint256;

    address private immutable i_owner;

    // constant variables cost less gas, for variables that do not change
    uint256 public constant MINIMUM_USD = 0.01 ether;
    address[] private s_funders;
    mapping(address funder => uint256) private s_addressToAmountFunded;

    AggregatorV3Interface private s_priceFeed;

    function fund() public payable {
        // msg.value.getConversionRate();

        // require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "Didn't send enough ETH");
        if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD) {
            revert FundMe__NotEnoughEth();
        }
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function withdraw() public payable onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset array
        s_funders = new address[](0);
        // withdraw funds

        // 1. transfer
        payable(msg.sender).transfer(address(this).balance);

        // 2. send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        if (sendSuccess != true) {
            revert FundMe__NotSend();
        }

        // 3. call
        // returns 2 variables, shown by placing them into perenthases on left -> ()
        (bool callSuccess /*bytes memory dataReturned*/, ) = payable(msg.sender)
            .call{value: address(this).balance}("");
        // require(callSuccess, "Call failed");
        if (callSuccess != true) {
            revert FundMe__NotCall();
        }
    }

    // NEED SEPOLIA ADDRESS
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    // the rest of the function code is inserted at place of "_;", if placed before the require, then function code gets executed before the require
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    // What happens when someone sends this contract ETH without calling the fund function.

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // View / Pure functions (Getters)
    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}

// original gas:                              1,001,173
// with constant:                               978,511
// with imutable:                               952,049
// replace require with revert error():         836,101
// ```solidity before your code when asking questions to people or AI. And ``` and after your code.
