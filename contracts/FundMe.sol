// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConverter} from "./PriceConverter.sol";

error ErrNotOwner();
error ErrWithdrawFail();
error ErrMinimumDonation();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MIN_DONATION_AMT = 5 * 1e18;
    address public immutable I_OWNER;
    mapping(address donator => uint256 amount) public donations;

    constructor() {
        I_OWNER = msg.sender;
    }

    modifier isOwner() {
        _isOwner();
        _;
    }

    function fund() public payable {
        if (msg.value.convertToUsd() < MIN_DONATION_AMT) {
            revert ErrMinimumDonation();
        }

        donations[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
        (bool success,) = payable(I_OWNER).call{value: address(this).balance}("");
        if (!success) revert ErrWithdrawFail();
    }

    function _isOwner() internal view {
        if (msg.sender != I_OWNER) revert ErrNotOwner();
    }
}
