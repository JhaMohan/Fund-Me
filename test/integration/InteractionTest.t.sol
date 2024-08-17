// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract InteractionTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteraction() public {
        // FundFundMe fundFundMe = new FundFundMe();
        // vm.deal(address(fundFundMe), 1e17);
        // fundFundMe.fundFundMe(address(fundMe));
        // // address owner = fundMe.getOwner();
        // // console.log("owner", owner);
        // // console.log("fundFundMe address", address(fundFundMe));
        // // console.log("USER", USER);
        // // console.log("msg.sender", msg.sender);
        // // console.log("balance of msg.sender", address(msg.sender).balance);
        // // Using vm.prank to simulate funding from the USER address
        // WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        // withdrawFundMe.withdrawFundMe(address(fundMe));
        // assert(address(fundMe).balance == 0);
        // assertEq(address(fundFundMe).balance, 1e17);

        //Fund Arrange
        FundFundMe fundFundMe = new FundFundMe();
        //Fund Act
        vm.prank(USER);
        fundFundMe.fundFundMe(address(fundMe)); //fund

        //Fund Assert
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER); //check USER is registered as a funder

        //Withdraw Arrange
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        //Withdraw Act
        vm.prank(msg.sender);
        withdrawFundMe.withdrawFundMe(address(fundMe)); //withdraw
        //Withdraw Assert
        assertEq(address(fundMe).balance, 0); //check funds were withdrawn
    }
}
