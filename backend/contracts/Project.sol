//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Project {
    string public name;
    uint256 public voteMin;
    address public tokenContract;
    address[] public users;
    address public owner;
    uint256 private taskId = 0;
    Task[] public tasks;
    mapping(uint256 => bool) doneVote;
    mapping(uint256 => ValueVote[]) valueVote;

    struct ValueVote {
        address voterAddress;
        uint256 value;
    }

    struct Task {
        uint256 id;
        string name;
        string description;
        string category;
        address assignee;
    }

    //TODO ASIGN NAME
    constructor(
        address _owner,
        string memory _name,
        uint256 _voteMin,
        address _tokenContract
    ) {
        owner = _owner;
        name = _name;
        voteMin = _voteMin;
        tokenContract = _tokenContract;
        users.push(_owner);
    }

    modifier OnlyUsers() {
        require(isUser(msg.sender));
        _;
    }

    function isUser(address userAddress) public view returns (bool) {
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] == userAddress) {
                return true;
            }
        }
        return false;
    }

    function getTasks() public view returns (Task[] memory projectTasks) {
        Task[] memory projectTasks = new Task[](tasks.length);
        for (uint256 i = 0; i < tasks.length; i++) {
            projectTasks[i] = tasks[i];
        }
        return projectTasks;
    }

    function createTask(
        string calldata _name,
        string calldata _description,
        string calldata _category
    ) public OnlyUsers {
        Task memory newTask = Task({
            id: taskId++,
            name: _name,
            description: _description,
            category: _category,
            assignee: address(0)
        });
        tasks.push(newTask);
    }

    function isTaskDone(uint256 _index) public {}

    function addUser(address _userAddress) public {}

    function voteTaskValue(uint256 _index, uint256 _value) public {}

    function voteTaskDone(uint256 _index) public {}
}
