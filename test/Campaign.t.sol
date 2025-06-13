// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std-1.9.6/Test.sol";
import "../src/Campaign.sol";

contract CampaignTest is Test {
    Campaign campaign;
    address creator = address(0x1234);
    address backer = address(0x5678);

    function setUp() public {
        vm.warp(1);
        vm.deal(backer, 2 ether);
        vm.deal(creator, 0);
        vm.startPrank(creator);
        campaign = new Campaign(1 ether, block.timestamp + 10);
        vm.stopPrank();
    }

    function testPledge() public {
        vm.prank(backer);
        campaign.pledge{value: 0.5 ether}();
        assertEq(campaign.pledged(), 0.5 ether);
        assertEq(campaign.contributions(backer), 0.5 ether);
    }

    function testWithdraw() public {
        vm.prank(backer);
        campaign.pledge{value: 1 ether}();
        vm.warp(block.timestamp + 11);
        vm.prank(creator);
        uint256 balBefore = creator.balance;
        campaign.withdraw();
        assertEq(creator.balance, balBefore + 1 ether);
        assertTrue(campaign.withdrawn());
    }

    function testRefund() public {
        vm.prank(backer);
        campaign.pledge{value: 0.5 ether}();
        vm.warp(block.timestamp + 11);
        uint256 balBefore = backer.balance;
        vm.prank(backer);
        campaign.refund();
        assertEq(backer.balance, balBefore + 0.5 ether);
        assertEq(campaign.contributions(backer), 0);
    }
}
