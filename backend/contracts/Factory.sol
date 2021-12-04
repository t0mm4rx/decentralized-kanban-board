//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "./Project.sol";

contract Factory {
    address[] public projects;

    function getUserProjects()
        public
        view
        returns (address[] memory _userProjects)
    {
        uint256 numberOfProjects = 0;
        for (uint256 i = 0; i < projects.length; i++) {
            Project projectTmp = Project(projects[i]);
            if (projectTmp.isUser(msg.sender)) {
                numberOfProjects++;
            }
        }
        address[] memory userProjects = new address[](numberOfProjects);
        uint256 counter = 0;
        for (uint256 i = 0; i < projects.length; i++) {
            Project projectTmp = Project(projects[i]);
            if (projectTmp.isUser(msg.sender)) {
                userProjects[counter++] = projects[i];
            }
        }
        return userProjects;
    }

    function createNewProject(
        string calldata _name,
        uint256 _voteMin,
        address _tokenContract
    ) public returns (address _newContract) {
        Project newProject = new Project(
            msg.sender,
            _name,
            _voteMin,
            _tokenContract
        );
        projects.push(address(newProject));
        return address(newProject);
    }
}
