<template>
  <div class="header">
    <h1>
      <a href="/">
        <span style="color: rgb(122, 122, 130)">
          Projects
          <span style="font-size: 0.7em">></span>
        </span>
      </a>
      {{ !!project ? project.name : "..." }}
      <span
        v-if="project !== null"
        class="header-button clickable"
        @click="() => addUserModal = true"
      >+ Add user</span>
      <span
        v-if="project !== null"
        class="header-button clickable"
        @click="() => usersModal = true"
      >Users</span>
    </h1>
    <div class="profile-container">
      <span
        v-if="project !== null"
        class="header-button clickable"
        @click="setNickname"
      >Get a nickname</span>
      <span
        class="avatar"
        :style="{ backgroundColor: seedColor(address.toLowerCase()).toHex() }"
      >{{ formatAvatar(getName(address)) }}</span>
    </div>
  </div>
  <div v-if="project === null" id="project-loader-overlay">
    <Loader />
  </div>
  <div v-if="project !== null" id="project-board">
    <div v-for="category in categories" :key="category" class="project-board-column">
      <h4>{{ category }}</h4>
      <div
        v-for="task in getTasks(category)"
        :key="task.name"
        class="project-board-task"
        :done="task.isDone"
        @click="highlightedTask = task"
      >
        <span class="project-board-task-title">{{ task.name }}</span>
        <div class="project-board-task-row">
          <span v-if="task.value" class="task-value">{{ task.value }} tokens</span>
          <span v-if="!task.value" />
          <span
            v-if="task.assignee"
            class="avatar"
            :style="{ backgroundColor: seedColor(task.assignee.toLowerCase()).toHex() }"
          >{{ formatAvatar(getName(task.assignee)) }}</span>
        </div>
        <div v-if="task.isDone" class="project-board-task-badge">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
            <path
              d="M20.285 2l-11.285 11.567-5.286-5.011-3.714 3.716 9 8.728 15-15.285z"
              fill="#333"
            />
          </svg>
        </div>
      </div>
      <div class="project-board-task" @click="() => openNewTaskModal(category)">
        <span>+ Create task</span>
      </div>
    </div>
    <div class="project-board-column project-board-column-new" @click="() => openNewTaskModal()">
      <h4>+ New category</h4>
    </div>
  </div>
  <Modal :open="createTaskModal" :onClose="() => createTaskModal = false" style="width: 400px">
    <h2>Create a new task</h2>
    <div class="label-input-wrapper">
      <span>Name</span>
      <input type="text" id="new-task-name" placeholder="Implement new feature" />
    </div>
    <div class="label-input-wrapper">
      <span>Category</span>
      <input type="text" id="new-task-category" placeholder="dev" />
    </div>
    <div class="label-input-wrapper">
      <span>Description</span>
      <textarea
        id="new-task-description"
        placeholder="This feature needs to follow these requirements..."
        style="resize: none;"
      />
    </div>
    <button class="primary-button" @click="createTask">Create</button>
  </Modal>
  <Modal
    :open="highlightedTask !== null"
    :onClose="() => highlightedTask = null"
    style="width: 500px"
  >
    <span>{{ highlightedTask.category }}</span>
    <h2>{{ highlightedTask.name }}</h2>
    <p class="highlight-description">{{ highlightedTask.description }}</p>
    <div class="highlight-row">
      <div>
        <span :style="{ marginBottom: '10px' }">Value</span>
        <span>
          <span
            v-if="highlightedTask.value"
            class="task-value-card"
          >{{ highlightedTask.value }} tokens</span>
          <span v-if="!highlightedTask.value">To determine</span>
          <span
            class="clickable modal-button"
            @click="() => voteForValue(highlightedTask)"
            v-if="!highlightedTask.isDone"
          >Estimate</span>
          <span
            class="clickable modal-button"
            @click="() => claimReward(highlightedTask)"
            v-if="highlightedTask.isDone"
          >Claim reward</span>
        </span>
      </div>
      <div>
        <span>Assignee</span>
        <span>
          {{ highlightedTask.assignee ? formatUser(highlightedTask.assignee) : "Available" }}
          <span
            class="clickable modal-button"
            @click="() => voteTaskDone(highlightedTask)"
            v-if="highlightedTask.assignee && !highlightedTask.isDone && highlightedTask.value"
          >Vote as done</span>
          <span
            class="clickable modal-button"
            v-if="!highlightedTask.assignee"
            @click="() => claim(highlightedTask)"
          >Claim</span>
        </span>
      </div>
    </div>
  </Modal>
  <Modal :open="addUserModal" :onClose="() => addUserModal = false">
    <h3>Add a new user to {{ project.name }}</h3>
    <div class="label-input-wrapper">
      <span>Address</span>
      <div class="input-button-row">
        <input type="text" id="add-user-address" placeholder="0x..." />
        <button class="primary-button" @click="addUser">add</button>
      </div>
    </div>
  </Modal>
  <Modal :open="usersModal" :onClose="() => usersModal = false" style="min-width: 450px">
    <span :style="{ fontSize: '1.5em', fontWeight: 'bold' }">Users</span>
    <div id="users-modal-listing" v-if="users">
      <div v-for="user of users" :key="user" class="users-modal-listing-user">
        <span v-if="!user.name">{{ user.address }}</span>
        <span v-if="user.name" :style="{ fontWeight: '500' }">
          {{ user.name }}
          <span
            v-if="user.address === project.owner"
            :style="{ color: 'rgb(94, 99, 223)' }"
          >(admin)</span>
        </span>
      </div>
    </div>
    <Loader v-if="!users" />
  </Modal>
</template>

<script>
import { getProject, createTask, addUser, voteForValue, claimTask, voteTaskDone, claimReward, getUsers, setNickname, getNickname } from "@/services/web3";
import { getAddress } from "@/services/wallet";
import Loader from "@/components/Loader";
import Modal from "@/components/Modal";
import seedColor from 'seed-color';


export default {
  components: { Loader, Modal },
  data: function () {
    return {
      project: null,
      createTaskModal: false,
      highlightedTask: null,
      addUserModal: false,
      subscribeMailModal: false,
      usersModal: false,
      users: null
    }
  },
  mounted: function () {
    getProject(this.$route.params.id).then(project => {
      this.project = project;
      getUsers(this.$route.params.id).then(async res => {
        const users = [];
        for (let address of res) {
          const name = await getNickname(this.$route.params.id, address).catch();
          users.push({
            address, name: name.length > 0 ? name : name
          });
        }
        this.users = users;
      }).catch();
    }).catch(err => this.$toast.error(`Cannot get project: ${err}`));
  },
  methods: {
    getTasks: function (category) {
      return this.project.tasks.filter(task => task.category === category);
    },
    openNewTaskModal: function (category) {
      if (category) {
        setTimeout(() => document.querySelector("#new-task-category").value = category, 50);
      }
      this.createTaskModal = true;
    },
    formatUser: function (address) {
      return address.substring(0, 6) + "..." + address.substring(40)
    },
    claim: async function (task) {
      claimTask(this.$route.params.id, task.id)
        .then(async () => {
          this.$toast.success("Claimed task!");
          task.assignee = await getAddress();
        })
        .catch(err => this.$toast.error(`Cannot claim task: ${err}`))
    },
    createTask: function () {
      const name = document.querySelector("#new-task-name").value;
      const category = document.querySelector("#new-task-category").value;
      const description = document.querySelector("#new-task-description").value;
      if (!name || !category || !description) {
        return this.$toast.error("Missing fields");
      }
      createTask(this.$route.params.id, name, description, category)
        .then(() => {
          this.$toast.success("Task created");
          this.project.tasks.push({
            name, description, category, isDone: false, valueVotes: [], assignee: null
          });
          this.createTaskModal = false;
        })
        .catch(err => this.$toast.error(`Unable to create the task: ${err}`));
    },
    addUser: function () {
      const address = document.querySelector("#add-user-address").value;
      if (!address) {
        return this.$toast.error("Missing address");
      }
      addUser(this.$route.params.id, address)
        .then(() => {
          this.$toast.success("User has been invited");
          this.addUserModal = false;
        })
        .catch(err => this.$toast.error(`Cannot add user: ${err}`));
    },
    voteForValue: function (task) {
      const amount = prompt("How much do you think this task is woth?");
      if (!amount) {
        return this.$toast.error("Missing value");
      }
      voteForValue(this.$route.params.id, task.id, amount)
        .then(() => {
          this.$toast.success("Voted!")
        })
        .catch(err => this.$toast.error(`Cannot vote: ${err}`));
    },
    voteTaskDone: function (task) {
      voteTaskDone(this.$route.params.id, task.id)
        .then(() => this.$toast.success("Voted this task as done!"))
        .catch(err => this.$toast.error(`Cannot vote: ${err}`));
    },
    claimReward: function (task) {
      claimReward(this.$route.params.id, task.id)
        .then(() => this.$toast.success("Reward collected!"))
        .catch(err => this.$toast.error(`Cannot collect reward: ${err}`));
    },
    setNickname: function () {
      const name = prompt("Enter your name");
      if (!name) {
        return this.$toast.error(`Missing input`);
      }
      setNickname(this.$route.params.id, name)
        .then(() => this.$toast.success("Set name!"))
        .catch(err => this.$toast.error(`Cannot set name: ${err}`));
    },
    formatAvatar: function (name) {
      if (name.startsWith('0x')) return name.substring(0, 3).toLowerCase();
      return name[0];
    },
    getName: function (address) {
      if (!this.users)
        return address
      const search = this.users.filter(a => a.address.toLowerCase() === address.toLowerCase());
      return search[0]?.name.length > 0 ? search[0].name : address;
    }, seedColor
  },
  computed: {
    categories: function () {
      return [...new Set(this.project.tasks.map(task => task.category))];
    },
    address: () => window.ethereum ? window.ethereum.selectedAddress : "0x"
  }
}
</script>

<style lang="scss" scoped>
h1 a {
  color: inherit;
  text-decoration: none;
}

#project-loader-overlay {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

#project-board {
  display: flex;
  overflow-x: auto;
  width: 100%;
}
.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  color: #fff;
  margin-left: 10px;
  margin-top: 5px;
  font-size: 16px;
  display: flex;
  font-weight: 400;
  justify-content: center;
  align-items: center;
}

.task-value {
  padding: 10px;
  background-color: #48bb78;
  border-radius: 5px;
  margin: 5px;
  color: #fff;
  font-weight: bold;
  font-size: 0.7em;
}

.task-value-card {
  margin-top: 10px;
  padding: 5px;
  background-color: #48bb78;
  border-radius: 5px;
  color: #fff;
  font-weight: bold;
  font-size: 0.7em;
}
.project-board-column {
  margin: 20px;
  width: 300px;
  min-width: 300px;
  height: 100%;

  h4 {
    margin-top: 0px;
  }
}

.project-board-task {
  box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px;
  margin: 20px 0px;
  padding: 20px;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  cursor: pointer;

  .project-board-task-title {
    font-weight: 500;
  }

  .project-board-task-row {
    margin-top: 20px;
    display: flex;
    justify-content: space-between;
  }
}

.project-board-task[done="true"] {
  background-color: rgb(219, 255, 219);
  position: relative;

  .project-board-task-title {
    text-decoration: line-through;
  }

  .project-board-task-badge {
    position: absolute;
    right: 0;
    top: 0;
    transform: translate(50%, -50%);
    width: 20px;
    height: 20px;
    border-radius: 100%;
    background-color: #afa;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;

    svg {
      width: 10px;
      height: auto;
    }
  }
}

.project-board-column-new {
  cursor: pointer;
}

#new-task-description {
  height: 200px;
}

.highlight-row {
  display: flex;
  flex-direction: column;

  > div {
    flex: 1;
    display: flex;
    flex-direction: column;
    margin: 10px 0px;

    span:nth-child(1) {
      font-size: 0.8em;
    }

    span:nth-child(2) {
      font-weight: 500;
      font-size: 1em;
    }
  }
}

.highlight-description {
  white-space: pre-line;
  max-height: 400px;
  overflow: auto;
}

.header {
  align-items: center;
  display: flex;
  justify-content: space-between;
  flex-direction: row;
  align-items: center;
}

.profile-container {
  display: flex;
  margin-right: 20px;
  flex-direction: row;
  justify-content: space-between;
}

.primary-text {
  float: right;
  padding: 5px;
}

.clickable {
  border-radius: 10px;
  background-color: #edf2f7;
  color: #1a202c;
  cursor: pointer;
}

.clickable:hover {
  background-color: #cbd5e0;
}

.modal-button {
  padding: 10px;
  border-radius: 5px;
  font-size: 0.9em !important;
  float: right;
}

.header-button {
  margin-left: 20px;
  font-size: 15px;
  font-weight: 500;
  color: #2d3748;
  padding: 10px;
  border-radius: 5px;
}

.users-modal-listing-user {
  border-bottom: 1px solid #edf2f7;
  margin: 10px 0px;
  padding-bottom: 5px;
}
</style>