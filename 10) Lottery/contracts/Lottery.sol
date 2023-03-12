//SPDX-License-Identifier:GPL-3.0

pragma solidity ^0.8.0;

/* This smart contract mimics a simple lottery system. Anyone can enter the lottery by transferring 1000 wei.
The lottery is for maximum 20 people. In an ideal scenario, the lottery owner runs the lotteryWinner function
when the lottery entry time is closed but here fore the sake of project, this functionality check has not 
been kept and the lottery owner can run the lotteryWinner function whenever he wants.
With the declaration of the winner, all the collected wei are then transferred to the winner. 
*/

contract Lottery {

    struct participant {
        address payable _address;
        bool enteredLottery;
        string name;
    }
    
    participant[] public participantList;
    mapping(address=>mapping(string=>bool)) public participantsEntered;
    address public owner;
   
    constructor() {
        owner=msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender==owner,"Only owner can call this function");
        _;
    }

    event Winner(string name);

    function participate(string memory _name) public payable {
        require(msg.value>=1000,"You have not transferred required amount to enter");
        require(participantList.length<20,"20 people have already entered lottery");
        require(participantsEntered[msg.sender][_name]==false,"You have already entered lottery");
        participantList.push(participant({_address:payable(msg.sender), name:_name,enteredLottery:true}));
        participantsEntered[msg.sender][_name]=true;        
    }

    function lotteryWinner() public payable onlyOwner returns(string memory) {
        uint random_no=uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participantList.length)))%participantList.length;
        participantList[random_no]._address.transfer(address(this).balance);
        emit Winner(participantList[random_no].name);
        return participantList[random_no].name;
    }

    

    
}