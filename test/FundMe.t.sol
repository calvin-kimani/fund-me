// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(address(fundMe), 0);
    }

    function test_MinimumDonationAmount() public view {
        assertEq(fundMe.MIN_DONATION_AMT(), 5e18);
    }

    function test_OwnerIsMsgSender() public view {
        assertEq(fundMe.I_OWNER(), msg.sender);
    }

    function test_ConverterVersion() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function test_WithdrawSuccess() public {
        address donator = makeAddr("donator");
        vm.deal(donator, 10 ether);

        // Confirm initial balances
        assertEq(donator.balance, 10 ether);
        assertEq(address(fundMe).balance, 0);

        // Donator funds the contract
        vm.startPrank(donator);
        fundMe.fund{value: 10 ether}();
        vm.stopPrank();

        // After funding: donator has 0, contract has 10
        assertEq(donator.balance, 0);
        assertEq(address(fundMe).balance, 10 ether);

        // Now withdraw as owner
        address owner = fundMe.I_OWNER();
        uint256 ownerStartBalance = owner.balance;

        vm.startPrank(owner);
        fundMe.withdraw();
        vm.stopPrank();

        // After withdraw: contract empty, owner got the funds
        assertEq(address(fundMe).balance, 0);
        assertEq(owner.balance, ownerStartBalance + 10 ether);
    }
}
