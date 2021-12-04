<template>
  <h1>
    <a href="/">Projects</a>
    > {{ !!project ? project.name : "..." }}
    <span
    v-if="project !== null"
    class="header-button"
    @click="() => addUserModal = true">Add user</span>
    <span
    class="header-button"
    @click="() => subscribeMailModal = true"
    v-if="project !== null">Subscribe to mail notifications</span></h1>
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
      @click="highlightedTask = task">
        <span class="project-board-task-title">{{ task.name }}</span>
        <div class="project-board-task-row">
          <span>{{ task.value ? task.value : "To determine" }}</span>
          <span>{{ task.assignee ? formatUser(task.assignee) : "Available" }}</span>
        </div>
        <div v-if="task.isDone" class="project-board-task-badge">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M20.285 2l-11.285 11.567-5.286-5.011-3.714 3.716 9 8.728 15-15.285z" fill="#333"/></svg>
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
      <textarea id="new-task-description" placeholder="This feature needs to follow this requirements..."/>
    </div>
    <button class="primary-button" @click="createTask">Create</button>
  </Modal>
  <Modal :open="highlightedTask !== null" :onClose="() => highlightedTask = null" style="width: 400px">
    <h2>{{ highlightedTask.name }}</h2>
    <p class="highlight-description">{{ highlightedTask.description }}</p>
    <div class="highlight-row">
      <div>
        <span>
          Value
          <span
          class="primary-text"
          @click="() => claim(highlightedTask)"
          v-if="!highlightedTask.value">
          Vote for value</span>
          <span
          class="primary-text"
          @click="() => claim(highlightedTask)"
          v-if="highlightedTask.assignee && !highlightedTask.isDone && highlightedTask.value">
          Vote as done</span>
        </span>
        <span>{{ highlightedTask.value ? highlightedTask.value : "To determine" }}</span>
      </div>
      <div>
        <span>
          Assignee
          <span
          class="primary-text"
          v-if="!highlightedTask.assignee"
          @click="() => claim(highlightedTask)">
          Claim</span></span>
        <span>{{ highlightedTask.assignee ? formatUser(highlightedTask.assignee) : "Available" }}</span>
      </div>
    </div>
  </Modal>
  <Modal :open="addUserModal" :onClose="() => addUserModal = false">
    <h2>Add a new user to {{ project.name }}</h2>
    <div class="label-input-wrapper">
      <span>Address</span>
      <input type="text" id="add-user-address" placeholder="0x..." />
    </div>
    <button class="primary-button" @click="addUser">Add</button>
  </Modal>
</template>

<script>
import { getProject, createTask, addUser } from "@/services/web3";
import { getAddress } from "@/services/wallet";
import Loader from "@/components/Loader";
import Modal from "@/components/Modal";

export default {
  components: { Loader, Modal },
  data: function () {
    return {
      project: null,
      createTaskModal: false,
      highlightedTask: null,
      addUserModal: false,
      subscribeMailModal: false
    }
  },
  mounted: function () {
    getProject(this.$route.params.id).then(project => this.project = project);
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
      task.assignee = await getAddress();
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
    }
  },
  computed: {
    categories: function () {
      return [...new Set(this.project.tasks.map(task => task.category))];
    }
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
    background-color: #AFA;
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

  > div {
    flex: 1;
    display: flex;
    flex-direction: column;
    margin: 10px;

    span:nth-child(2) {
      font-weight: 500;
      font-size: 1.4em;
    }
  }
}

.highlight-description {
  white-space: pre-line;
}

.primary-text {
  float: right;
}

.header-button {
  margin-left: 20px;
  font-size: 0.7em;
  color: rgb(94, 99, 223);
  cursor: pointer;
  padding: 10px;
  background-color: #eee;
  border-radius: 10px;
}
</style>