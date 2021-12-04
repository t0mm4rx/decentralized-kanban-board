import { fakeProjects, fakeProject } from "./mockup"
import * as config from "@/config.json"
import * as factoryAbi from "@/assets/factory.json"
import * as projectAbi from "@/assets/project.json"
import { ethers } from "ethers";

export const getFactoryContract = () => {
	if (!window.factory) {
		window.factory = new ethers.Contract(config.factoryAddress, factoryAbi);
	}
	return window.factory;
};

export const getProjectContract = (address) => {
	return new ethers.Contract(address, projectAbi);
};

export const getProjects = () => {
	return new Promise((resolve) => {
		setTimeout(() => {
			return resolve(fakeProjects);
		}, 300);
	});
}

export const getProject = (address) => {
	address;
	return new Promise((resolve) => {
		setTimeout(() => {
			return resolve(fakeProject);
		}, 600);
	});
};