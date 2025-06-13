// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std-1.9.6/Test.sol";
import "../src/HelloWorld.sol";

contract HelloWorldTest is Test {
    HelloWorld public hello;

    function setUp() public {
        hello = new HelloWorld("Hello, DeCentraFund!");
    }

    function testInitialMessage() public view {
        assertEq(hello.message(), "Hello, DeCentraFund!");
    }

    function testSetMessage() public {
        hello.setMessage("Updated Message");
        assertEq(hello.message(), "Updated Message");
    }
}
