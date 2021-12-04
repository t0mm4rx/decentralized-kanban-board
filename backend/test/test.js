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
      await project.voteTaskValue(taskId, 1000);
      await project.voteTaskDone(taskId);
      const numberOfVote = await project.getNumberOfVotes(taskId);
      expect(numberOfVote.toNumber()).to.equal(1);
    });

    it("It should value vote the task", async function () {
      await project.createTask('name', 'description', 'category');
      const tasks = await project.getTasks();
      const taskId = tasks[0][0].toNumber();
      await project.voteTaskValue(taskId, 1000);
      const taskValue = await project.getCurrentTaskValue(taskId);
      expect(taskValue._value.toNumber()).to.equal(1000);
    });

    it("Should add an user", async () => {
      const [, user] = await ethers.getSigners();
      await project.addUser(user.address);
      const users = await project.getUsers()
      expect(users).to.include(user.address);
    })


    it("Should add an user", async () => {
      const [, user] = await ethers.getSigners();
      await project.addUser(user.address);
      const users = await project.getUsers()
      expect(users).to.include(user.address);
    })

    it('Should set the task done', async () => {
      const [, user1, user2, user3] = await ethers.getSigners();
      await project.addUser(user1.address);
      await project.addUser(user2.address);
      await project.addUser(user3.address);
      await project.createTask('name', 'description', 'category');
      const tasks = await project.getTasks();
      const taskId = tasks[0][0].toNumber();
      await project.connect(user1).voteTaskValue(taskId, 1000);
      await project.connect(user1).voteTaskDone(taskId);
      await project.connect(user2).voteTaskValue(taskId, 1000);
      await project.connect(user2).voteTaskDone(taskId);
      await project.connect(user3).voteTaskValue(taskId, 1000);
      await project.connect(user3).voteTaskDone(taskId);
      expect(await project.isTaskDone(taskId)).to.equal(true);
    })

    it('Should claim the task', async () => {
      const [owner] = await ethers.getSigners();
      await project.createTask('name', 'description', 'category');
      const tasks = await project.getTasks();
      const taskId = tasks[0][0].toNumber();
      await project.claim(taskId);
      expect(await project.getTaskAssignee(taskId)).to.equal(owner.address);
    })

  })
});

