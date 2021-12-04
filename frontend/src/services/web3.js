import { fakeProject } from "./mockup"
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
	return new ethers.Contract(address, projectAbi.default);
};

export const test = async () => {
	const factory = getFactoryContract();
	// console.log(factory)
	const res = await factory.getUserProjects().catch(console.error)
	console.log('res', res);
}

export const getProjects = async () => {
	const factory = getFactoryContract();
	const projectHashs = await factory.getUserProjects();
	const result = [];
	for (let address of projectHashs) {
		// Get name
		result.push({
			address, name: 'Dust Impact'
		});
	}
	return result;
	// console.log(projectHashs);
	// return new Promise((resolve) => {
	// 	setTimeout(() => {
	// 		return resolve(fakeProjects);
	// 	}, 300);
	// });
}

export const getProject = (address) => {
	address;
	return new Promise((resolve) => {
		setTimeout(() => {
			return resolve(fakeProject);
		}, 600);
	});
};

export const createProject = async (name) => {
	name;
	const factory = getFactoryContract();
	return await factory.createNewProject();
}