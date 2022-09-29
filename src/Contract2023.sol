// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/solmate/src/tokens/ERC20.sol";
import "lib/solmate/src/auth/Owned.sol";
import "lib/forge-std/src/console.sol";

contract Contract2023 is ERC20, Owned {
    uint256 deadline = 1672531200; //GMT: Sunday, January 1, 2023 0:00:00
    
    constructor () ERC20(
        "Contract2023",
        "C23",
        18
    ) Owned(msg.sender) {
        _mint(owner, 100 ether);
    }

    function transfer(address to, uint256 amount) public override returns(bool) {
        require( msg.sender == owner || block.timestamp >= deadline, "User is not owner or it is not 2023 yet." );        
        return super.transfer(to, amount);
    } 

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }     
}
