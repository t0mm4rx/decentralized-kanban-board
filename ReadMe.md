# Decentralized Kanban board

This project is a decentralized Trello-like tool, to manage a sprint planning tasks.
Every task is valued by the community, by a blind vote.
Once the task is voted as done, the assignee of the task is sent an amount of the choosen ERC-20 token corresponging of the task.

This system provide many advantages:
- transparent remuneration of a project's contributors
- ready-to-use equity allocation framwork in case of the token is a security token
- method of remuneration that maximizes team efficiency and individual effort

Every project (collection of tasks) is a smart contract.
A factory smart contract creates project smart contract and keep a listing of it.

## Project architecture

### Smart contracts

#### Factory contract

This contract creates and stores all created projects.

- **projects**: array of projects addresses
- **getUserProjects(user: address)**: returns an array of all the projects in which a user is
- **createNewProject(name: string)**: deploys a new instance of a project, store the address of the instance, add the deployer in the users, and return instance's address

#### Project contract

This contract stores all the data for a project.
A project is a collection of tasks, and users that have access to it.

When a task is done, this contract sends the corresponding amount of the reward token to the assignee.
The ERC-20 will be sent from this contract. All the funds used as rewards should be sent on this contract instance.

- **task**: struct:
- - **name**: string
- - **description**: string
- - **category**: string
- - **assignee**: address of the assignee of the task, default 0x0
- - **doneVotes**: mapping of address => boolean, contains the votes of users concerning the status of the task, done or not
- - **valueVotes**: mapping of address => uint, contains the votes of users concerning the value of the task

- **name**: string const, name of the project
- **voteMin**: uint const, the minimal number of votes to consider a task as done
- **rewardAddress**: address const, the address of the ERC-20 used to reward the assignees
- **owner**: address const, the deployer of this contract and admin

- **tasks**: array of the tasks
- **users**: array of the users who have access to this project
- **createTask(name: string, description: address, category: string)**: add a new task in tasks
- **isTaskDone(index: uint)**: returns wether the task at index is done (sum(tasks[index].valueVotes) >= minVotes)
- **addUser(user: address)**: adds a user to users
- **voteTaskValue(index: uint, value: uint)**: adds a new vote in tasks[index].valueVotes
- **voteTaskDone(index: uint)**: adds a new vote in tasks[index].doneVotes

## Deploy your own infrastructure

### Deploy the factory contract

```sh
python3 deploy_contracts.sh
```

### Deploy the frontend

```sh
cd frontend && yarn build
```

This will produce a dist/ folder that you can upload wherever you want.

## Launching the frontend in developement

```sh
cd frontend && yarn serve
```