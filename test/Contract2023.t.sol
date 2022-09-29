// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Contract2023.sol";
import "lib/solmate/src/tokens/ERC20.sol";
import "lib/solmate/src/auth/Owned.sol";

contract Contract2023Test is Test {
    Contract2023 public coin;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        coin = new Contract2023();
        owner = coin.owner();
        user1 = address(0x1);
        user2 = address(0x2);
    }

    function testMint() public {
        assertEq(coin.balanceOf(owner), 100 ether);
        assertEq(coin.totalSupply(), 100 ether);
    }

    function testTransferByOwner() public {
        vm.prank(coin.owner());
            coin.transfer(user1, 10 ether);
        assertEq(coin.balanceOf(owner), 90 ether);
        assertEq(coin.balanceOf(user1), 10 ether);
    }

    function testTransferByCommonUserBefore2023() public {
        coin.mint(user1, 100 ether);
        
        vm.warp(1672531199); // GMT: Saturday, December 31, 2022 23:59:59 
        vm.prank(user1);
            vm.expectRevert(bytes("User is not owner or it is not 2023 yet."));       
            coin.transfer(user2, 10 ether);
        assertEq(coin.balanceOf(user1), 100 ether);
        assertEq(coin.balanceOf(user2), 0 ether);
    }

    function testTransferByCommonUserIn2023() public {
        coin.mint(user1, 100 ether);
    
        vm.warp(1672531200); //GMT: Sunday, January 1, 2023 0:00:00 
        vm.prank(user1);
            coin.transfer(user2, 10 ether);
        assertEq(coin.balanceOf(user1), 90 ether);
        assertEq(coin.balanceOf(user2), 10 ether);
    }    
}
