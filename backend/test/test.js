const { expect } = require("chai");
const { ethers } = require("hardhat");
const BigNumber = require('bignumber.js');

describe("Starting Test", function () {
  let factory;
  let project;
  beforeEach(async function () {
    const Factory = await ethers.getContractFactory("Factory");
    factory = await Factory.deploy();
    await factory.deployed();
    await factory.createNewProject('project1', 2, '0x2791bca1f2de4661ed88a30c99a7a9449aa84174');
    const [projectAddress] = await factory.getUserProjects();
    const Project = await ethers.getContractFactory("Project");
    project = await Project.attach(projectAddress);
  });

  describe("Deployment", function () {
    it("It should set the right owner", async function () {
      const [owner] = await ethers.getSigners();
      const ownerAddress = owner.address;
      expect(await project.owner()).to.equal(ownerAddress);
    });
  })

  describe("Project", function () {
    it("It should create a project", async function () {
      await factory.createNewProject('project2', 2, '0x2791bca1f2de4661ed88a30c99a7a9449aa84174');
      const projects = await factory.getUserProjects();
      expect(projects.length).to.equal(2);
    });

    it("It should create a new task", async function () {
      await project.createTask('name', 'description', 'category');
      const tasks = await project.getTasks();
      expect(tasks.length).to.equal(1);
    });

    it("It should done vote the task", async function () {
      await project.createTask('name', 'description', 'category');
      const tasks = await project.getTasks();
      const taskId = tasks[0][0].toNumber();
      await project.voteTaskDone(taskId);
      const numberOfVote = await project.getNumberOfVotes(taskId);
      expect(numberOfVote.toNumber()).to.equal(1);
    });
    it("It should value vote the task", async function () {
      await project.createTask('name', 'description', 'category');
      const tasks = await project.getTasks();
      const taskId = tasks[0][0].toNumber();
      await project.voteTaskValue(taskId, 1000);
      await project.voteTaskValue(taskId, 2000);
      const res = await project.getCurrentTaskValue(taskId);
      console.log(res)
    });



  })
});

