
// SPDX-License-Identifier: GPL-3.0

/* This smart contract can be used by a blood bank to store record of donors and receiver patients. The smart 
contract also maintains every blood transaction linked to the patient.

The records are maintained as : 

Suppose a patient comes to the blood bank. If he is visiting first time, his details are taken and he is registered.
This way a list of patients is maintained. At the same time, along with the details of the patient, 
the ledger also stores the list of transactions in which the patient is involved in. So, that whenever a receiver 
receives blood, he can track down who is donating the blood and what is the donor's history.

*/

pragma solidity ^0.8.0;

contract BloodBank {
    
    address owner;

    constructor() {
        owner = msg.sender;
    }

   
    enum PatientType {
        Donor,
        Receiver
    }

   
    struct BloodTransaction {
        PatientType patientType;
        uint256 time;
        address from;
        address to;
    }

    
    struct Patient {
        uint256 aadhar;
        string name;
        uint256 age;
        string bloodGroup;
        uint256 contact;
        string homeAddress;
        BloodTransaction[] bT;
    }

    
    Patient[] PatientRecord;

    
       mapping(uint256 => uint256) PatientRecordIndex;

    
    event Successfull(string message);

   
    function newPatient(
        string memory _name,
        uint256 _age,
        string memory _bloodGroup,
        uint256 _contact,
        string memory _homeAddress,
        uint256 _aadhar
    ) external {
        
        require(msg.sender == owner, "only admin can register new patient");

        
        uint256 index = PatientRecord.length;

        
        PatientRecord.push();
        PatientRecord[index].name = _name;
        PatientRecord[index].age = _age;
        PatientRecord[index].bloodGroup = _bloodGroup;
        PatientRecord[index].contact = _contact;
        PatientRecord[index].homeAddress = _homeAddress;
        PatientRecord[index].aadhar = _aadhar;

        
        PatientRecordIndex[_aadhar] = index;

        emit Successfull("Patient added successfully");
    }

    
    function getPatientRecord(uint256 _aadhar)
        external
        view
        returns (Patient memory)
    {
        uint256 index = PatientRecordIndex[_aadhar];
        return PatientRecord[index];
    }

    
    function getAllRecord() external view returns (Patient[] memory) {
        return PatientRecord;
    }

    
    function bloodTransaction(
        uint256 _aadhar,
        PatientType _type,
        address _from,
        address _to
    ) external {
        
        require(
            msg.sender == owner,
            "only hospital can update the patient's blood transaction data"
        );

        
        uint256 index = PatientRecordIndex[_aadhar];

        BloodTransaction memory txObj = BloodTransaction({
            patientType: _type,
            time: block.timestamp,
            from: _from,
            to: _to
        });

        PatientRecord[index].bT.push(txObj);

        

        emit Successfull(
            "Patient blood transaction data is updated successfully"
        );
    }
}
