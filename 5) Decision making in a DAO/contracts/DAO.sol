//SPDX-License-Identifier:GPL-3.0


/* This smart contract mimics decision making in a Decentralised Autonomous Organization. The owner of the
contract creates proposals with a predefined deadline to respond and a minimum quorum of votes before 
executing that proposal. All members of DAO can vote on proposals till the deadline is open. 
The proposal is said to be accepted if it receives the quorum votes before the deadline is reached. 
In case the quorum of votes is not received, the deadline is extended by 7 days.
*/


pragma solidity ^0.8.0;

contract DAO {

  struct Proposal {
        string description;
        uint256 voteCount;
        bool executed;
        uint256 id;
    }

    struct Voter {
        bool voted;
        bool exists;
    }

     address public owner;
    uint256 public deadline;
    uint256 public totalVoters;
    uint256 public quorum;
    Proposal[] public proposals;
    mapping(uint256 => mapping(address => Voter)) public voters;


    event ProposalAdded(uint256 proposalId, string description);
    event Voted(uint256 proposalId, address voter);
    event ProposalExecuted(uint256 proposalId);


    constructor(uint256 _deadline, uint256 _totalVoters) {
        owner = msg.sender;
        deadline = _deadline;
        totalVoters=_totalVoters;
        quorum=_totalVoters/2+1;      
    }


    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }


    function addProposal(string memory _description) public onlyOwner {
        uint256 proposalId = proposals.length;
        proposals.push(Proposal({
            description: _description,
            voteCount: 0,
            executed: false,
            id: proposalId
        }));
        emit ProposalAdded(proposalId, _description);
    }


    function vote(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        Voter storage voter = voters[_proposalId][msg.sender];
        require(voter.exists == false, "You have already voted");
        voter.voted = true;
        voter.exists = true;
        proposal.voteCount++;
        emit Voted(_proposalId, msg.sender);
    }


    function executeProposal(uint256 _proposalId) public onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.executed == false, "This proposal has already been executed");
        require(proposal.voteCount >= quorum, "The quorum has not been met yet");
        proposal.executed = true;
        emit ProposalExecuted(_proposalId);
    }

    
    function extendDeadline() public onlyOwner {
        require(block.timestamp > deadline, "The deadline has not passed yet");
        deadline += 7 days;
    }
}


