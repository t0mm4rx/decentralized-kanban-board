// import { fakeProject } from "./mockup"
import * as config from "@/config.json"
import * as factoryAbi from "@/assets/factory.json"
import * as projectAbi from "@/assets/project.json"
import { ethers } from "ethers";
import { getProvider } from "@/services/wallet";

export const getFactoryContract = () => {
	if (!window.factory) {
		window.factory = new ethers.Contract(config.factoryAddress, factoryAbi.default, getProvider().getSigner());
	}
	return window.factory;
};

export const getProjectContract = (address) => {
	return new ethers.Contract(address, projectAbi.default, getProvider().getSigner());
};

export const getProjects = async () => {
	const factory = getFactoryContract();
	const projectHashs = await factory.getUserProjects();
	const result = [];
	for (let address of projectHashs) {
		const project = getProjectContract(address);
		const name = await project.name().catch(console.error);
		console.log(address, name);
		result.push({
			address, name
		});
	}
	return result;
}

export const getProject = async (address) => {
	const project = getProjectContract(address);
	const tasks = await project.getTasks();

	const tasksTreated = [];
	for (let task of tasks) {
		tasksTreated.push({
			name: task[1],
			description: task[2],
			category: task[3],
			assignee: parseInt(task[4], 16) !== 0 ? task[4] : null,
			valueVotes: [],
			isDone: /* await project.isTaskDone(task[0]) */false
		});
	}

	return {
		name: await project.name(),
		address: address,
		owner: await project.owner(),
		tasks: tasksTreated
	};
	// return new Promise((resolve) => {
	// 	setTimeout(() => {
	// 		return resolve(fakeProject);
	// 	}, 600);
	// });
};

export const createProject = (name, votes, token) => {
	const factory = getFactoryContract();
	return factory.createNewProject(name, votes, token);
}

export const createTask = (address, name, description, category) => {
	const project = getProjectContract(address);
	return project.createTask(name, description, category);
}