const { expect } = require("chai");
const { ethers } = require("hardhat");




describe("Starting Test", function () {
  let factory;
  let project;
  beforeEach(async function () {
    const Factory = await ethers.getContractFactory("Factory");
    factory = await Factory.deploy();
    await factory.deployed();
    await factory.createNewProject();
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
    it("It should create a new task", async function () {
      const [owner] = await ethers.getSigners();
      const ownerAddress = owner.address;
      expect(await project.owner()).to.equal(ownerAddress);
    });
  })
});

