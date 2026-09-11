pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/MockERC20.sol";

contract VaultTest is Test {
    MockERC20 token;
    Vault vault;
    address user = address(1);

    function setUp() public {
        token = new MockERC20();
        vault = new Vault(address(token));
        token.mint(user, 100 ether);
    }

    function testDeposit() public {
        vm.startPrank(user);
        token.approve(address(vault), 100 ether);
        vault.deposit(100 ether);
        vm.stopPrank();

        assertEq(vault.shares(user), 100 ether);
        assertEq(token.balanceOf(address(vault)), 100 ether);
    }

    function testWithdraw() public {
        vm.startPrank(user);
        token.approve(address(vault), 100 ether);
        vault.deposit(100 ether);

        vault.withdraw(40 ether);
        vm.stopPrank();

        assertEq(vault.shares(user), 60 ether);
        assertEq(token.balanceOf(address(vault)), 60 ether);
        assertEq(token.balanceOf(user), 40 ether);
    }
}
