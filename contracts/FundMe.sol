// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minDonationUsd = 5 * 1e18;
    address public owner;
    mapping(address donator => uint256 amount) public donations;

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner(){
      require(msg.sender == owner);
      _;
    }

    function fund() public payable {
      require(msg.value.convertToUsd() >= minDonationUsd, "Minimum donation not met");
      donations[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
      (bool success,) = payable(owner).call{value: address(this).balance}("");
      require(success, "Withdraw fail");
    }
}
