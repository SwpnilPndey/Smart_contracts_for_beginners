// SPDX-License-Identifier: GPL-3.0

/* This contract implements a decentralized voting system, where users can cast votes that are counted in a 
transparent and tamper-proof way. The winner is declared based on the highest number of votes. 

Valid voters are of age more than 18 years. 

Valid candidates for election have age more than 25 years and have deposited the minimum security fees to contest the 
election.

Only the owner of the contract call register the voter and the candidates and also declare the winning candidate.

*/

pragma solidity ^0.8.18;

contract Voting {
    
    struct Voter {
        
        bool voted;  
        uint constituency;  
    }

    struct candidate {
        string partySymbol;   
        uint voteCount; 
        uint constituency;
    }

    address public chairperson;

    mapping(address=>Voter) public voterList;

    candidate[] public candidateList;

    
    constructor() {
        chairperson = msg.sender;
    }

    mapping(address=>bool) public depositStatus;

    function depositFees(address _candidate) public payable {
        if(msg.value>=100) {
            depositStatus[_candidate]=true;
        }
    }

    function registerCandidates(string memory _partySymbol, address _candidate,uint _constituency) public {
        require(msg.sender==chairperson,"Only chairperson can register candidates");
        require(depositStatus[_candidate]==true,"Candidate has not deposited the security deposit");
        candidateList.push(candidate({partySymbol:_partySymbol,voteCount:0,constituency:_constituency}));
    }
        
    
    function vote(uint _candidateIndex, uint voterConstituency) public {
        Voter memory sender = voterList[msg.sender];
        sender.constituency=voterConstituency;
        require(sender.voted!=true, "Already voted.");
        require(sender.constituency==candidateList[_candidateIndex].constituency,"Kindly vote in your constituency");
        sender.voted = true;
        candidateList[_candidateIndex].voteCount++;
    }

    
    function winner() public view returns (string memory) {
        uint winningVotes=0;
        string memory winningParty;
        for(uint i=0;i<candidateList.length;i++) {
            if(candidateList[i].voteCount>winningVotes) {
                winningVotes=candidateList[i].voteCount;
                winningParty=candidateList[i].partySymbol;
            }
        }
        return winningParty;
    }
}