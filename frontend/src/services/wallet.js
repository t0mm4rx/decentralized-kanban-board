import { ethers } from "ethers";

export const getProvider = () => {
	if (!window.ethereum) {
		return null;
	}
	if (window.provider) {
		return window.provider;
	}
	window.provider = new ethers.providers.Web3Provider(window.ethereum, "any");
	return window.provider;
};

export const metamaskAvailable = () => {
	return !!window.ethereum;
};

export const isConnected = async () => {
	const provider = getProvider();
	const accounts = await provider.listAccounts();
  return accounts.length > 0;
};

export const getAddress = async () => {
	const provider = getProvider();
	const accounts = await provider.listAccounts();
	if (accounts.length > 0) {
		return accounts[0];
	}
	return null;
};

export const connect = () => {
	const provider = getProvider();
	return provider.send("eth_requestAccounts", []);
};