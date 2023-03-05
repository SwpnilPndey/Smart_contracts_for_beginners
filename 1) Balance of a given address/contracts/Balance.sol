//SPDX-License-Identifier:GPL-3.0

pragma solidity >=0.8.0;

// This smmart contract returns the balance of an EOA (Externally Owned Account) address or contract address.
// Only the owner of the smart contract can call the balanceOf function.
// This contract is for deployment to local ganache blockchain (edit truffle-config.js to deploy to other networks)

contract Balance {
    address public owner;
    
    constructor () {
        owner=msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender==owner,"Only owner can call this function");
        _;
    }
    function balanceOf(address _address) view public onlyOwner returns(uint) {
        return(_address.balance);
    }
}