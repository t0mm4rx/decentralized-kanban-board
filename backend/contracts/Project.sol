pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Project {
    string public name;
    uint256 public voteMin;
    address public tokenContract;
    address[] private users;
    address public owner;
    uint256 private taskId = 0;
    Task[] public tasks;
    mapping(uint256 => DoneVote[]) doneVote;
    mapping(uint256 => ValueVote[]) valueVote;
    mapping(address => string) nickNames;

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
        bool isDone;
        bool isClaimed;
    }

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
        require(isUser(msg.sender), "You are not a user of this project");
        _;
    }

    modifier isAssigned(uint256 _taskId) {
        require(
            tasks[_taskId].assignee != address(0),
            "The task is not assigned"
        );
        _;
    }

    modifier OnlyAdmin() {
        require(owner == msg.sender, "You are not admin of this project");
        _;
    }

    modifier isDone(uint256 _taskId) {
        bool hasUserFinishedTask = false;
        for (uint256 i = 0; i < doneVote[_taskId].length; i++) {
            if (doneVote[_taskId][i].voterAddress == tasks[_taskId].assignee) {
                hasUserFinishedTask = true;
            }
        }
        require(
            hasUserFinishedTask || msg.sender == tasks[_taskId].assignee,
            "The task is not done yet"
        );
        _;
    }

    function getNickName() public view returns (string memory _nickName) {
        return nickNames[msg.sender];
    }

    function getUsers() public view returns (address[] memory _users) {
        uint256 userCounter = 0;
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] != address(0)) {
                userCounter++;
            }
        }
        address[] memory filteredUsers = new address[](userCounter);
        uint256 userIndex = 0;
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] != address(0)) {
                filteredUsers[userIndex] = users[i];
                userIndex++;
            }
        }
        return filteredUsers;
    }

    function isUser(address userAddress) public view returns (bool) {
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] == userAddress) {
                return true;
            }
        }
        return false;
    }

    function setNickName(string calldata nickName) public OnlyUsers {
        nickNames[msg.sender] = nickName;
    }

    function getTaskValue(uint256 _taskId)
        public
        view
        returns (uint256 _value)
    {
        uint256 cumulativeTaskValue = 0;
        for (uint256 i = 0; i < valueVote[_taskId].length; i++) {
            cumulativeTaskValue =
                cumulativeTaskValue +
                valueVote[_taskId][i].value;
        }
        if (valueVote[_taskId].length == 0) {
            return 0;
        }
        return cumulativeTaskValue / valueVote[_taskId].length;
    }

    function claimTask(uint256 _taskId) public OnlyUsers returns (bool) {
        require(
            tasks[_taskId].assignee == address(0),
            "Task is already claimed"
        );
        tasks[_taskId].assignee = msg.sender;
        return true;
    }

    function getTasks() public view returns (Task[] memory _projectTasks) {
        Task[] memory projectTasks = new Task[](tasks.length);
        for (uint256 i = 0; i < tasks.length; i++) {
            projectTasks[i] = tasks[i];
        }
        return projectTasks;
    }

    function getTaskAssignee(uint256 _taskId) public view returns (address) {
        return tasks[_taskId].assignee;
    }

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
            assignee: address(0),
            isDone: false,
            isClaimed: false
        });
        tasks.push(newTask);
        taskId = taskId + 1;
        return taskId - 1;
    }

    function isTaskDone(uint256 _taskId) public view returns (bool) {
        return tasks[_taskId].isDone;
    }

    function getNumberOfVotes(uint256 _taskId) public view returns (uint256) {
        return doneVote[_taskId].length;
    }

    function getCurrentTaskValue(uint256 _taskId)
        public
        view
        returns (uint256 _value, uint256 numberOfVote)
    {
        uint256 cumulativeTaskValue = 0;
        for (uint256 i = 0; i < valueVote[_taskId].length; i++) {
            cumulativeTaskValue =
                cumulativeTaskValue +
                valueVote[_taskId][i].value;
        }
        if (valueVote[_taskId].length == 0) {
            return (0, 0);
        }
        return (
            cumulativeTaskValue / valueVote[_taskId].length,
            valueVote[_taskId].length
        );
    }

    function addUser(address _userAddress) public OnlyAdmin {
        bool isUserAlreadyRegistered = false;
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] == _userAddress) {
                isUserAlreadyRegistered = true;
            }
        }
        require(isUserAlreadyRegistered == false, "User is already registered");
        users.push(_userAddress);
    }

    function deleteUser(address _userAddress) public OnlyAdmin {
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] == _userAddress) {
                delete users[i];
            }
        }
    }

    function voteTaskValue(uint256 _taskId, uint256 _value) public OnlyUsers {
        bool hasUserVoted = false;
        for (uint256 i = 0; i < valueVote[_taskId].length; i++) {
            if (valueVote[_taskId][i].voterAddress == msg.sender) {
                hasUserVoted = true;
            }
        }
        require(hasUserVoted == false, "User has already voted");
        ValueVote memory newValueVote = ValueVote({
            voterAddress: msg.sender,
            value: _value
        });
        valueVote[_taskId].push(newValueVote);
    }

    function claimReward(uint256 _taskId) public {
        require(tasks[_taskId].isDone == true, "The task is not done");
        require(
            tasks[_taskId].isClaimed == false,
            "The task has already been claimed"
        );
        require(
            tasks[_taskId].assignee == msg.sender,
            "You are not assigned to this task"
        );
        IERC20 rewardToken = IERC20(tokenContract);
        uint256 balance = rewardToken.balanceOf(address(this));
        uint256 taskValue = getTaskValue(_taskId);
        require(balance >= taskValue, "The contract balance is too low");
        rewardToken.transfer(msg.sender, taskValue);
    }

    function voteTaskDone(uint256 _taskId)
        public
        OnlyUsers
        isAssigned(_taskId)
        isDone(_taskId)
    {
        bool hasUserVoted = false;
        bool hasUserVotedValue = false;
        for (uint256 i = 0; i < valueVote[_taskId].length; i++) {
            if (valueVote[_taskId][i].voterAddress == msg.sender) {
                hasUserVotedValue = true;
            }
        }
        require(
            hasUserVotedValue == true,
            "User has not voted for the value of the task"
        );
        for (uint256 i = 0; i < doneVote[_taskId].length; i++) {
            if (doneVote[_taskId][i].voterAddress == msg.sender) {
                hasUserVoted = true;
            }
        }
        require(hasUserVoted == false, "User has already voted");
        DoneVote memory newVote = DoneVote({
            voterAddress: msg.sender,
            idDone: true
        });
        doneVote[_taskId].push(newVote);
        if (doneVote[_taskId].length >= voteMin) {
            tasks[_taskId].isDone = true;
        }
    }
}
