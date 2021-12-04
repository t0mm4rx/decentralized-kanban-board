<template>
  <h2><a href="/">Projects</a> > {{ !!project ? project.name : "..." }}</h2>
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
      :done="task.isDone">
        <span class="project-board-task-title">{{ task.name }}</span>
        <span>{{ getValue(task) }}</span>
        <div v-if="task.isDone" class="project-board-task-badge">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M20.285 2l-11.285 11.567-5.286-5.011-3.714 3.716 9 8.728 15-15.285z" fill="#333"/></svg>
        </div>
      </div>
      <div class="project-board-task">
        <span>+ Create task</span>
      </div>
    </div>
    <div class="project-board-column">
      <h4>+ New category</h4>
    </div>
  </div>
</template>

<script>
import { getProject } from "@/services/web3";
import Loader from "@/components/Loader";

export default {
  components: { Loader },
  data: function () {
    return {
      project: null
    }
  },
  mounted: function () {
    getProject().then(project => this.project = project);
  },
  methods: {
    getTasks: function (category) {
      return this.project.tasks.filter(task => task.category === category);
    },
    getValue: function (task) {
      return (task.valueVotes.reduce((a, b) => a + b) / task.valueVotes.length).toFixed(2);
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
h2 a {
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
}

.project-board-task {
  box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px;
  margin: 20px 0px;
  padding: 20px;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
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
</style>