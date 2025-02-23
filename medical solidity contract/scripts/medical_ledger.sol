// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecords {
    enum Role { None, Doctor, Patient, Insurance }
    
    struct Record {
        string data;
        bool doctorApproval;
        bool patientApproval;
        bool insuranceApproval;
    }
    
    mapping(address => Role) public roles;
    mapping(address => Record[]) public records;
    
    event RecordAdded(address indexed user, string data);
    event RecordRevoked(address indexed user, uint index);
    
    modifier onlyParticipants() {
        require(roles[msg.sender] != Role.None, "Not authorized");
        _;
    }
    
    function assignRole(address _user, Role _role) public {
        roles[_user] = _role;
    }
    
    function addRecord(address _user, string memory _data) public onlyParticipants {
        records[_user].push(Record(_data, false, false, false));
        emit RecordAdded(_user, _data);
    }
    
    function approveRecord(address _user, uint _index) public onlyParticipants {
        require(_index < records[_user].length, "Invalid record index");
        if (roles[msg.sender] == Role.Patient) {
            records[_user][_index].patientApproval = true;
        } else if (roles[msg.sender] == Role.Doctor) {
            records[_user][_index].doctorApproval = true;
        } else if (roles[msg.sender] == Role.Insurance) {
            records[_user][_index].insuranceApproval = true;
        }
    }
    
    function revokeRecord(address _user, uint _index) public onlyParticipants {
        require(_index < records[_user].length, "Invalid record index");
        records[_user][_index].doctorApproval = false;
        records[_user][_index].patientApproval = false;
        records[_user][_index].insuranceApproval = false;
        emit RecordRevoked(_user, _index);
    }
    
    function getRecords(address _user) public view returns (Record[] memory) {
        return records[_user];
    }

}