// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // us -> FundMeTest -> FundMe
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        // console.log(msg.sender);
        // console.log(address(this));
        assertEq(fundme.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    // what we can do to work with  addresses outside our system?
    // 1. Unit
    //  - Testing a specific part of our code
    // 2. Integration
    // - Testing how our code works with other parts of our code
    // 3. Forked
    // - Testing our code on a simulated real environment
    // 4. Staging
    // - Testing our code in a real environmentthat is not prod

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // hey the next line should revert!
        fundme.fund(); // send 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // next TX will be sent by USER
        fundme.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayofFunder() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();

        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundme.withdraw();
    }

    function testWithdrawWithSingleOwner() public funded {
        // Arrange
        uint256 startingOwnerBalane = fundme.getOwner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;
        // Act
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        // Assert
        uint256 endingOwnerBalane = fundme.getOwner().balance;
        uint256 endingFundmeBalance = address(fundme).balance;
        assertEq(endingFundmeBalance, 0);
        assertEq(
            startingOwnerBalane + startingFundmeBalance,
            endingOwnerBalane
        );
    }

    function testingWithdrawWithMultipleFunders() public {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank
            // vm.deal
            // both thing can be done by vm.hoax
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }

        // ACT
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;

        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);
        // Assert
        assertEq(address(fundme).balance, 0);
        assertEq(
            startingOwnerBalance + startingFundmeBalance,
            fundme.getOwner().balance
        );
    }

    function testingCheaperWithdrawWithMultipleFunders() public {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank
            // vm.deal
            // both thing can be done by vm.hoax
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }

        // ACT
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;

        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.startPrank(fundme.getOwner());
        fundme.cheaperWithdraw();
        vm.stopPrank();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);
        // Assert
        assertEq(address(fundme).balance, 0);
        assertEq(
            startingOwnerBalance + startingFundmeBalance,
            fundme.getOwner().balance
        );
    }
}
