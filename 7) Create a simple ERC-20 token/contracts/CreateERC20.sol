// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/*
About the code : 

This solidity smart contract creates ERC20 tokens with user defined name and symbol.
The owner of the token contract can mint as many tokens as he wishes to and can also burn tokens,
although in real world, there should be checks on the maximum number of tokens that can be issued
to control inflation of token. 

Here for the purpose of the project we have initialised the name, symbol, decimal and the total supply 
of tokens Although a separate mint function can be created to create new tokens based on 
creators wish whenever he/ she wants to mint new tokens.

The smart contract provides the functionality to transfer the tokens from the token holder 
to any account address by calling transfer() function  
The smart contract also provides the functionality to transfer tokens on token holder's 
behalf using transferFrom() function. For this functionality, allowance limit is set for 
the address which will be transferring tokens on token holder's behalf. The token holder 
approves the allowance limit of all such addresses which can send tokens on its behalf. 
The ERC-20 standard mandates use of minimum 6 functions - function to return total supply 
of tokens, function to return the token balance of addresses, function to transfer token 
from one address to other, function to approve the allowance limit in case third party 
transfers tokens on token holders behalf, function for third party transfer from 
token holder's address to a recipient address and lastly a function to return the allowance 
limit set by the token holder for the third partyh address which will transfer the tokens 
on token holders behalf.
The ERC-20 standard also mandates minimum 2 events to be created - event to be logged 
whenever token is transferred from one address to the other and event to be logged whenever 
an allowance limit is approved by a token holder for the transfer of token by a third party
on token holder's behalf. 
*/

/* To ensure that all the 6 functions and the two events are present in the token contract,
we first create an interface contract having the mandated 6 functions and 2 event. Then we 
can inherit this interface contract into out token contract.
*/ 

interface IERC20 {
    function totalSupply() external view returns(uint); 
    function balanceOf(address tokenHolder) external view returns (uint);
    function transfer(address reciever, uint tokenAmount) external;
    function approve(address thirdParty, uint tokenAmount) external;
    function transferFrom(address sender, address reciever, uint tokenAmount) external;
    function allowanceLimit(address tokenHolder, address thirdParty) external view returns (uint allowance);
    event Transfer(address indexed sender, address indexed reciever, uint tokenAmount);
    event Approval(address indexed tokenHolder, address indexed thirdParty, uint tokenAmount);
}

contract CreateERC20 is IERC20 { 
    
    mapping(address=>uint) public tokenBalance;
    mapping (address=>mapping(address=>uint)) allowance; 
    
    string public tokenName;
    string public tokenSymbol;
    uint public decimal; 
    // decimal is used to present the token balance to the user in easy to understand format

    uint public mintedTokens; 
    address public creator; 

  

    constructor() {
        creator=msg.sender;
        tokenName="BITS PILANI";
        tokenSymbol="BITS";
        decimal=0;
        mintedTokens=50000;
        tokenBalance[creator]=mintedTokens;
    }

    function totalSupply() external view override returns(uint) {
        return mintedTokens;
    } 
    function balanceOf(address tokenHolder) external view override returns (uint) {
        return tokenBalance[tokenHolder];
    }
    function transfer(address reciever, uint tokenAmount) external override {
        require(tokenBalance[msg.sender]>=tokenAmount,"Insufficient tokens");
        require(tokenAmount>0,"Kindly transfer tokens more than zero");
        tokenBalance[msg.sender]-=tokenAmount;
        tokenBalance[reciever]+=tokenAmount;
        emit Transfer(msg.sender, reciever, tokenAmount);
    }
    function approve(address thirdParty, uint tokenAmount) external override {
        require(tokenBalance[msg.sender]>=tokenAmount,"Insufficient balance");
        require(tokenAmount>0,"Kindly get approval for tokens more than zero");
        allowance[msg.sender][thirdParty]+=tokenAmount;
        emit Approval(msg.sender, thirdParty, tokenAmount);
    }
    function transferFrom(address sender, address reciever, uint tokenAmount) external override {
        require(tokenAmount>0,"Kindly transfer tokens more than zero");
        require(tokenBalance[sender]>=tokenAmount,"Insufficient balance");
        require(allowance[sender][msg.sender]>=tokenAmount,"Insufficient allowance");
        tokenBalance[sender]-=tokenAmount;
        tokenBalance[reciever]+=tokenAmount;
        allowance[sender][msg.sender]-=tokenAmount;
        emit Transfer(sender, reciever, tokenAmount);
    }
    function allowanceLimit(address _tokenHolder, address _thirdParty) external view override returns (uint) {
        return(allowance[_tokenHolder][_thirdParty]);
    }  
}   


