// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentPortal {
    address owner;

    struct Student {
        address walletAddress;
        string name;
        string email;
        string phoneNumber;
        string dateOfBirth;
        string localGovernmentArea;
        string state;
        string country;
        string department;
        string faculty;
        uint32 time_enrolled;
    }

    Student[] students;

    mapping(uint => address) registeredStudents;

    event StudentCreated();
    event StudentUpdated(uint32 indexed index);
    event StudentDeleted(uint32 indexed index);

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    // Create new student and push to storage array
    function createStudent(
        address _wallet,
        string memory _name,
        string memory _email,
        string memory _phone,
        string memory _dateOfBirth,
        string memory _lga,
        string memory _state,
        string memory _country,
        string memory _department,
        string memory _faculty
    ) public isOwner {
        // Add new Student to Students array
        students.push(
            Student(
                _wallet,
                _name,
                _email,
                _phone,
                _dateOfBirth,
                _lga,
                _state,
                _country,
                _department,
                _faculty,
                uint32(block.timestamp)
            )
        );

        // Populate mapping with index::address key-value pair
        registeredStudents[students.length - 1] = _wallet;

        // Emit associated event
        emit StudentCreated();
    }

    // Get all students in array
    function getStudents() public view returns (Student[] memory) {
        return students;
    }

    // Get a student at specific index in array
    function getStudent(
        uint32 _index
    ) public view returns (Student memory student_) {
        student_ = students[_index];
    }

    // Update student at specific index in array
    function updateStudent(
        uint32 _index,
        string memory _name,
        string memory _email,
        string memory _phone
    ) external isOwner {
        // Create copy of student at array index in storage
        Student storage st = students[_index];

        // Update dynamic student properties
        st.name = _name;
        st.email = _email;
        st.phoneNumber = _phone;

        // Emit associated event
        emit StudentUpdated(_index);
    }

    // Delete student from array
    function deleteStudent(uint32 _index) external isOwner {
        // Delete from students array and mapping
        delete students[_index];
        delete registeredStudents[_index];

        // Emit associated event
        emit StudentDeleted(_index);
    }
}
