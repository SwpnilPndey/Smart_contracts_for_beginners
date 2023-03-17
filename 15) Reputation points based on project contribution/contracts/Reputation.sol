//SPDX-License-Identifier:GPL-3.0

/*This smart contract creates a simple reputation system based on contributions done by a contributor to various projects.
For the sake of the project, the weight of each project has been kept as one(1). However in real scenario, the weightage may be 
different for different projects.

*/

pragma solidity ^0.8.18;

contract ReputationSystem {

    address[] contributors;
    
    mapping (uint256 => address[]) public projectContributions;
    mapping (address => uint256) public userPoints;

    function contribute(uint256 projectId) public {
        projectContributions[projectId].push(msg.sender);
        userPoints[msg.sender] ++;
    }

    function getContributors(uint256 projectId) public view returns (address[] memory) {
        return projectContributions[projectId];
    }

}
