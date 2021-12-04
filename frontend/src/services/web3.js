import { fakeProjects, fakeProject } from "./mockup"

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