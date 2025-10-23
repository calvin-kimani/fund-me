// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConverter} from "./PriceConverter.sol";

error ErrNotOwner();
error ErrWithdrawFail();
error ErrMinimumDonation();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MIN_DONATION_AMT = 5 * 1e18;
    address public immutable i_owner;
    mapping(address donator => uint256 amount) public donations;

    constructor() {
        i_owner = msg.sender;
    }

    modifier isOwner(){
      if(msg.sender != i_owner)
        revert(ErrNotOwner());
      _;
    }

    function fund() public payable {
      require(msg.value.convertToUsd() >= MIN_DONATION_AMT, "Minimum donation not met");
      donations[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
      (bool success,) = payable(i_owner).call{value: address(this).balance}("");
      if(!success){
        revert(ErrWithdrawFail());
      }
    }
}
