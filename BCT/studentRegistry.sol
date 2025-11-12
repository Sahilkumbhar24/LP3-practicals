// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentRegistry {
    struct Student {
        uint256 id;
        string name;
        uint8 age;
        string dept;
    }

    Student[] private students;
    mapping(uint256 => uint256) private idToIndex; // id -> index+1
    event StudentAdded(uint256 id, string name);
    event StudentUpdated(uint256 id, string name);
    event EtherReceived(address indexed from, uint256 amount);
    event FallbackCalled(address indexed from, uint256 value, bytes data);

    receive() external payable {
        emit EtherReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data);
    }

    function addStudent(
        uint256 id,
        string calldata name,
        uint8 age,
        string calldata dept
    ) external {
        require(idToIndex[id] == 0, "ID exists");
        students.push(Student(id, name, age, dept));
        idToIndex[id] = students.length; // store index+1
        emit StudentAdded(id, name);
    }

    function updateStudent(
        uint256 id,
        string calldata name,
        uint8 age,
        string calldata dept
    ) external {
        uint256 idx = idToIndex[id];
        require(idx != 0, "Not found");
        Student storage s = students[idx - 1];
        s.name = name;
        s.age = age;
        s.dept = dept;
        emit StudentUpdated(id, name);
    }

    function getStudentById(uint256 id)
        external
        view
        returns (uint256, string memory, uint8, string memory)
    {
        uint256 idx = idToIndex[id];
        require(idx != 0, "Not found");
        Student memory s = students[idx - 1];
        return (s.id, s.name, s.age, s.dept);
    }

    function count() external view returns (uint256) {
        return students.length;
    }
}
