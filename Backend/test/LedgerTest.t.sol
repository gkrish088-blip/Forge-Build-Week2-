// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import "../src/game.sol";
import "../src/ledger.sol";

contract LedgerTest is Test {
    Ledger ledger;
    GLDToken token;

    function setUp() public {
        token = new GLDToken(21000);
        ledger = new Ledger(address(token));
    }

    function testTokenDeploy() public view {
        assertTrue(address(token) != address(0));
    }

    function testLedgerDeploy() public view {
        assertTrue(address(ledger) != address(0));
    }

    function testPersonMade() public {
        address user = address(1);
        vm.prank(user);
        ledger.createNewPerson("Krish");
        (string memory name, , , , , , bool exists) = ledger.addressToPerson(
            user
        );
        assertTrue(exists);
        assertEq(name, "Krish");
    }

    function testSamePersonTwice() public {
        address user = address(1);
        vm.prank(user);
        ledger.createNewPerson("Krish");

        vm.prank(user);
        vm.expectRevert("Person already exists");
        ledger.createNewPerson("Krish");
    }
    function testTokenTransferToUser() public {
        address user = address(1);

        token.transfer(user,100);
        uint256 bal = token.balanceOf(user);
        assertEq(bal,100);
        
    }
    function testApproveWorks() public {
        address user = address(1);

        token.transfer(user,100);
        vm.prank(user);
        token.approve(address(ledger),100);
        uint256 allow = token.allowance(user,address(ledger));
        assertEq(allow,100);
    }
    function testBuyCow() public {
        address user = address(1);
        vm.prank(user);
        ledger.createNewPerson("Krish");
        token.transfer(user,100);
        vm.prank(user);
        token.approve(address(ledger),100);
        vm.prank(user);
        ledger.buyCow();

        uint256 userBal = token.balanceOf(user);
        uint256 gameBal = token.balanceOf(address(ledger));

        (string memory name,uint256 cows,,,,,) = ledger.addressToPerson(user);

        assertEq(name,"Krish");
        assertEq(cows,1);
        assertEq(userBal, 80);
        assertEq(gameBal,20) ;
    }
    function testBuyCowWithoutApproval() public {
        address user = address(1);
        vm.prank(user);
        ledger.createNewPerson("Krish");
        token.transfer(user,100);
        vm.prank(user);
        vm.expectRevert();
        ledger.buyCow();
    }
    function testSellCow() public {
        address user = address(1);
        vm.prank(user);
        ledger.createNewPerson("Krish");
        token.transfer(user,100);
        vm.prank(user);
        token.approve(address(ledger),100);
        vm.prank(user);
        ledger.buyCow();
        vm.prank(user);
        ledger.buyCow();
        vm.prank(user);
        ledger.sellCow();

        uint256 userBal = token.balanceOf(user);
        uint256 gameBal =  token.balanceOf(address(ledger));
        
        (,uint256 cows,,,,,) = ledger.addressToPerson(user);
        assertEq(cows,1);
        assertEq(userBal,80);
        assertEq(gameBal,20);

    }
}
