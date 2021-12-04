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
    mapping(uint256 => DoneVote[]) doneVote;
    mapping(uint256 => ValueVote[]) valueVote;

    struct ValueVote {
        address voterAddress;
        uint256 value;
    }

    struct DoneVote {
        address voterAddress;
        bool idDone;
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

    //todo set function setVoteMin
    function getTasks() public view returns (Task[] memory projectTasks) {
        Task[] memory projectTasks = new Task[](tasks.length);
        for (uint256 i = 0; i < tasks.length; i++) {
            projectTasks[i] = tasks[i];
        }
        return projectTasks;
    }

    //todo function claim

    function createTask(
        string calldata _name,
        string calldata _description,
        string calldata _category
    ) public OnlyUsers returns (uint256) {
        Task memory newTask = Task({
            id: taskId,
            name: _name,
            description: _description,
            category: _category,
            assignee: address(0)
        });
        tasks.push(newTask);
        taskId = taskId + 1;
        return taskId - 1;
    }

    // function isTaskDone(uint256 _id) public view returns (bool) {
    //     if (doneVote[_id] >= voteMin) {
    //         return true;
    //     }
    //     return false;
    // }

    function getNumberOfVotes(uint256 _taskId) public view returns (uint256) {
        return doneVote[_taskId].length;
    }

    function getCurrentTaskValue(uint256 _taskId)
        public
        view
        returns (uint256)
    {
        uint256 cumulativeTaskValue = 0;
        for (uint256 i = 0; i < valueVote[_taskId].length; i++) {
            cumulativeTaskValue =
                cumulativeTaskValue +
                valueVote[_taskId][i].value;
        }
        return cumulativeTaskValue / valueVote[_taskId].length;
    }

    function addUser(address _userAddress) public {}

    function voteTaskValue(uint256 _taskId, uint256 _value)
        public
        returns (bool)
    {
        for (uint256 i = 0; i < valueVote[_taskId].length; i++) {
            if (valueVote[_taskId][i].voterAddress == msg.sender) {
                return false;
            }
        }
        ValueVote memory newValueVote = ValueVote({
            voterAddress: msg.sender,
            value: _value
        });
        valueVote[_taskId].push(newValueVote);
        return true;
    }

    function voteTaskDone(uint256 _taskId) public returns (bool) {
        for (uint256 i = 0; i < doneVote[_taskId].length; i++) {
            if (doneVote[_taskId][i].voterAddress == msg.sender) {
                console.log("user already voted");
                return false;
            }
        }
        DoneVote memory newVote = DoneVote({
            voterAddress: msg.sender,
            idDone: true
        });
        doneVote[_taskId].push(newVote);
        return true;
    }
}
