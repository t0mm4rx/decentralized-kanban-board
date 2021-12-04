//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Project {
    string public name;
    uint256 public voteMin;
    address public tokenContract;
    address[] public users;
    address public owner;
    Task[] public tasks;
    struct Task {
        string name;
        string description;
        string category;
        address assignee;
        mapping(address => bool) doneVote;
        mapping(address => uint256) valueVote;
    }

    constructor(address _owner) {
        owner = _owner;
        users.push(_owner);
    }

    function createTask(
        string calldata _name,
        string calldata _description,
        string calldata _category
    ) public {}

    function isUser(address callerAddress) public view returns (bool) {
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] == callerAddress) {
                return true;
            }
        }
        return false;
    }

    function isTaskDone(uint256 _index) public {}

    function addUser(address _userAddress) public {}

    function voteTaskValue(uint256 _index, uint256 _value) public {}

    function voteTaskDone(uint256 _index) public {}
}
