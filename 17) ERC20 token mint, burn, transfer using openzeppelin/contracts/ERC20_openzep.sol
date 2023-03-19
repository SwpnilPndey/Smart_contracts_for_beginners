//SPDX-License-Identifier:GPL-3.0



pragma solidity ^0.8.18;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public owner;
    constructor(uint256 initialSupply) ERC20("My Token", "MTK") {
        _mint(msg.sender, initialSupply);
        owner=msg.sender;
    }

    modifier OnlyOwner {
        require(msg.sender==owner,"You are not the owner");
        _;
    }

    function mint(uint256 amount) public OnlyOwner {
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) public OnlyOwner {
       _burn(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns(bool success) {
        uint initialBalance=balanceOf(recipient);
        _transfer(msg.sender, recipient, amount);
        if(balanceOf(recipient)==initialBalance+amount) {
            return true;
        }
        else 
        return false;
    }
}
