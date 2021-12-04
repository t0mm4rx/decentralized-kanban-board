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
        for (uint256 i = 0; i < projects.length; i++) {
            Project projectTmp = Project(projects[i]);
            uint256 counter = 0;
            if (projectTmp.isUser(msg.sender)) {
                userProjects[counter] = projects[i];
                counter++;
            }
        }
        return userProjects;
    }

    function createNewProject() public returns (address _newContract) {
        Project newProject = new Project(msg.sender);
        projects.push(address(newProject));
        return address(newProject);
    }
}
