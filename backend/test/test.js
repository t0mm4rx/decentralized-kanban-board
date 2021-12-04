const { expect } = require("chai");
const { ethers } = require("hardhat");




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
      console.log("CREATING A NEW PROJECT\n\n")
      await factory.createNewProject('project2', 2, '0x2791bca1f2de4661ed88a30c99a7a9449aa84174');
      const res = await factory.getUserProjects();
      console.log(res)
    });
    // it("It should create a new task", async function () {
    //   await project.createTask('name', 'description', 'category');
    //   const tasks = await project.getTasks()
    //   expect(tasks.length).to.equal(1);
    // });

  })
});

