import requests
import json
import os

print("Compiling the contracts...")
os.system("cd backend && npx hardhat compile")

factoryBuild = json.load(open("./backend/artifacts/contracts/Factory.sol/Factory.json"))
projectBuild = json.load(open("./backend/artifacts/contracts/Project.sol/Project.json"))

print("Copying new ABIs in the frontend...")
json.dump(factoryBuild['abi'], open("./frontend/src/assets/factory.json", "w"))
json.dump(projectBuild['abi'], open("./frontend/src/assets/project.json", "w"))

print("Deploying factory contract...")
req = requests.post(
	"https://api-connect.starton.io/v1/smart-contract/from-bytecode",
	json={
		'networkId': 'POLYGON_MAINNET',
		'bytecode': factoryBuild['bytecode'],
		'abi': factoryBuild['abi'],
		'params': [],
		'compilerVersion': '0.8.4',
		'name': 'Factory'
	},
	headers={
		'x-api-key': 'pk_13f910956993480fb87511cf5ee4a5a3'
	}
)
print(f"Deployed at {req.json()['address']}")