// SPDX-License-Identifier: MIT

/* This smart contract implements a job portal system which connects unskilled and unorganized
 migrant workers with job providers. It can eliminate their exploitation by middlemen, 
 such as unrecognized agents and contractors. A worker can register with the portal by 
 creating their profile and uploading labor history, skills, availability, and other 
 personal details. Then, a job provider can directly connect with the worker. 

 */

pragma solidity ^0.8.18;

contract MigrantWorkerJobPortal {
    
    address public admin;
    uint256 public totalApplicants;
    uint256 public totalJobs;
    
    constructor() {
        admin = msg.sender;
        totalApplicants = 0;
        totalJobs = 0;
    }
    
    struct Applicant {
        uint256 id;
        string name;
        string laborHistory;
        string skills;
        string availability;
        string personalDetails;
        uint256 rating;
    }
    
    struct Job {
        uint256 id;
        string title;
        string description;
        uint256 salary;
        bool isAvailable;
    }
    
    mapping(uint256 => Applicant) public applicants;
    mapping(uint256 => Job) public jobs;
    mapping(address => mapping(uint256 => uint256)) public applicantRatings;
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }
    
    function addApplicant(string memory _name, string memory _laborHistory, string memory _skills, string memory _availability, string memory _personalDetails) public {
        totalApplicants++;
        applicants[totalApplicants] = Applicant(totalApplicants, _name, _laborHistory, _skills, _availability, _personalDetails, 0);
    }
    
    function getApplicantDetails(uint256 _id) public view returns (uint256, string memory, string memory, string memory, string memory, string memory, uint256) {
        Applicant memory applicant = applicants[_id];
        return (applicant.id, applicant.name, applicant.laborHistory, applicant.skills, applicant.availability, applicant.personalDetails, applicant.rating);
    }
    
    function addJob(string memory _title, string memory _description, uint256 _salary) public onlyAdmin {
        totalJobs++;
        jobs[totalJobs] = Job(totalJobs, _title, _description, _salary, true);
    }
    
    function getJobDetails(uint256 _id) public view returns (uint256, string memory, string memory, uint256, bool) {
        Job memory job = jobs[_id];
        return (job.id, job.title, job.description, job.salary, job.isAvailable);
    }
    
    function applyForJob(uint256 _jobId, uint256 _applicantId) public {
        require(jobs[_jobId].isAvailable, "Job not available.");
        jobs[_jobId].isAvailable = false;
        applicantRatings[msg.sender][_applicantId] = 0;
    }
    
    function rateApplicant(uint256 _applicantId, uint256 _rating) public {
        require(applicantRatings[msg.sender][_applicantId] == 0, "You have already rated this applicant.");
        require(_rating >= 1 && _rating <= 5, "Invalid rating. Rating must be between 1 and 5.");
        applicants[_applicantId].rating = (_rating + applicants[_applicantId].rating) / 2;
        applicantRatings[msg.sender][_applicantId] = _rating;
    }
    
    function getApplicantRating(uint256 _applicantId) public view returns (uint256) {
        return applicants[_applicantId].rating;
    }
    
}
