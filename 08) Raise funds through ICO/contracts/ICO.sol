// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/*

This solidity smart contract is to raise fund using Initial Coin Offerings process. The
fund raiser creates ERC20 tokens with a name and a symbol.The amount of tokens set for offerings
is set by the fund raiser. The fund raiser sets the number of ethers which the token buyer must 
transfer to the contract to recieve one unit of token.

The contract then transfers all the collected ethers to the account of the fund raiser. 

Here we have initialised the name, symbol, decimal and the total supply of tokens
Although a separate mint function can be created to create new tokens based on creators wish 
whenever he/ she wants to mint new tokens. Same way the tokens can also be burnt as per need. 

ERC20 standard : 

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

To ensure that all the 6 functions and the two events are present in the token contract,
we first create an interface contract having the mandated 6 functions and 2 event. Then we 
have inherited this interface contract into our token contract.

*/ 

interface IERC_20 {
    function totalSupply() external view returns(uint); 
    function balanceOf(address tokenHolder) external view returns (uint);
    function transfer(address reciever, uint tokenAmount) external;
    function approve(address thirdParty, uint tokenAmount) external;
    function transferFrom(address sender, address reciever, uint tokenAmount) external;
    function allowanceLimit(address tokenHolder, address thirdParty) external view returns (uint allowance);
    event Transfer(address indexed sender, address indexed reciever, uint tokenAmount);
    event Approval(address indexed tokenHolder, address indexed thirdParty, uint tokenAmount);
}

contract ICO is IERC_20 { 
    
    mapping(address=>uint) public tokenBalance;
    mapping (address=>mapping(address=>uint)) allowance; 
    mapping(address=>uint) public etherSent;
    
    string public tokenName;
    string public tokenSymbol;
    uint public decimal; 
    // decimal is used to present the token balance to the user in easy to understand format

    uint public totalICO; 
    address payable public fundraiser; 
    

   

    constructor() {
        fundraiser=payable(msg.sender);
        tokenName="Restaurant business";
        tokenSymbol="RST";
        decimal=0;
        totalICO=50000;
        tokenBalance[fundraiser]=totalICO;
    }

    function totalSupply() external view override returns(uint) {
        return totalICO;
    } 
    function balanceOf(address tokenHolder) external view override returns (uint) {
        return tokenBalance[tokenHolder];
    }
    function transfer(address reciever, uint tokenAmount) external override {
        require(fundraiser==payable(msg.sender),"You are not authorised to transfer tokens");
        require(tokenBalance[msg.sender]>=tokenAmount,"Insufficient tokens");
        require(tokenAmount>0,"Kindly transfer tokens more than zero");
        require(etherSent[reciever]==tokenAmount,"User has not sent designated ethers to buy tokens");
        tokenBalance[msg.sender]-=tokenAmount;
        tokenBalance[reciever]+=tokenAmount;
        etherSent[reciever]-=tokenAmount;
        emit Transfer(msg.sender, reciever, tokenAmount);
    }
    function approve(address thirdParty, uint tokenAmount) external override {
        require(fundraiser==payable(msg.sender),"You are not authorised to approve");
        require(tokenBalance[msg.sender]>=tokenAmount,"Insufficient balance");
        require(tokenAmount>0,"Kindly get approval for tokens more than zero");
        allowance[msg.sender][thirdParty]+=tokenAmount;
        emit Approval(msg.sender, thirdParty, tokenAmount);
    }
    function transferFrom(address sender, address reciever, uint tokenAmount) external override {
        require(fundraiser==payable(sender),"Tokens cannot be transferred from this sender");
        require(tokenAmount>0,"Kindly transfer tokens more than zero");
        require(tokenBalance[sender]>=tokenAmount,"Insufficient balance");
        require(allowance[sender][msg.sender]>=tokenAmount,"Insufficient allowance");
        require(etherSent[reciever]==tokenAmount,"User has not sent designated ethers to buy tokens");
        tokenBalance[sender]-=tokenAmount;
        tokenBalance[reciever]+=tokenAmount;
        allowance[sender][msg.sender]-=tokenAmount;
        etherSent[reciever]-=tokenAmount;
        emit Transfer(sender, reciever, tokenAmount);
    }
    function allowanceLimit(address _tokenHolder, address _thirdParty) external view override returns (uint) {
        return(allowance[_tokenHolder][_thirdParty]);
    }  
    function recieveEthers() external payable { //function to recieve ethers from token buyers
        etherSent[msg.sender]=msg.value;
    }
    function transferToFundaraiser() external payable {
        fundraiser.transfer(address(this).balance);
    }
}   