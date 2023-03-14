//SPDX-License-Identifier:GPL-3.0

pragma solidity ^0.8.0;

contract Crowdfunding {
       
    address payable public owner;
    uint public totalFundingGoal;
    uint public currentFunding;
    mapping(address => uint) public contributors;
    
    event FundingReceived(address contributor, uint amount);
    event FundingGoalReached(string _message);
    
    constructor(uint _totalFundingGoal) {
        owner=payable(msg.sender);
        totalFundingGoal = _totalFundingGoal;
        currentFunding=0;
    }
    
    function contribute() public payable {
        require(msg.value > 0, "Must contribute some ether");
        require(address(this).balance <= totalFundingGoal, "All funding received.");
        contributors[msg.sender] += msg.value;
        currentFunding+=msg.value;
        emit FundingReceived(msg.sender, msg.value);
    }
    
        
    function transferToOwner() public payable {
        require(msg.sender==owner,"Only owner can call this function");
        require(currentFunding==address(this).balance,"There is a mismatch of funds");
        require(currentFunding>=totalFundingGoal,"Funding goal not reached");
        payable(msg.sender).transfer(address(this).balance);
        emit FundingGoalReached("Funding goal reached");
    }
    
    function withdraw() public {
        require(address(this).balance<totalFundingGoal,"Funding goal already reached. Now can't withdraw");
        require(contributors[msg.sender] > 0, "No contribution to withdraw");
        uint amount = contributors[msg.sender];
        contributors[msg.sender] = 0;
        currentFunding-=amount;
        payable(msg.sender).transfer(amount);
    }
}

