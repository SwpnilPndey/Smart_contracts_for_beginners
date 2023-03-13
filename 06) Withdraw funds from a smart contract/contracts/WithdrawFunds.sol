//SPDX-License-Identifier:GPL-3.0

pragma solidity ^0.8.0;

/*This is a very basic smart contract which allows users to withdraw funds from the smart contract. The person 
withdrawing the fund should be authorized by the owner of the contract before attempting to withdraw funds. 
The smart contract throws error if the smart contract doesnot have sufficient fund. 
*/

contract WithdrawFunds {
    address public owner;
    mapping (address=>bool) public authorisedList;
    

    constructor() payable {
        owner=msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender==owner, " You are not the owner");
        _;
    }

    function authorize(address _address) public onlyOwner {
        authorisedList[_address]=true;        
    }

    function withdraw(uint256 _amount) public {
        require(address(this).balance>_amount,"Insufficient balance");
        require(authorisedList[msg.sender]==true,"You are not authorized to withdraw");
        payable(msg.sender).transfer(_amount);

    }

    function checkBalance(address _address) public view returns(uint256) {
        return(_address.balance);
    }
}