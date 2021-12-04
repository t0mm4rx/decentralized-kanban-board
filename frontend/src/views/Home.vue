<template>
  <h1>Projects</h1>
  <div v-if="projects !== null" id="projects-listing">
    <div
    v-for="project in projects"
    :key="project.name"
    class="projects-listing-item"
    @click="() => redirectProject(project.address)">
      <h3>{{ project.name }}</h3>
      <img :src="`https://picsum.photos/200/50?a=${project.name}`" />
    </div>
    <div class="projects-listing-item" @click="() => createProjectModal = true">
      <h3>+ Create a new project</h3>
      <img :src="`https://picsum.photos/200/50?a=create`" />
    </div>
  </div>
  <div v-if="projects === null" id="projects-loading-overlay">
    <Loader />
  </div>
  <Modal :open="createProjectModal" :onClose="() => createProjectModal = false" style="width: 400px">
    <h2>New project</h2>
    <div class="label-input-wrapper">
      <span>Name</span>
      <input type="text" id="create-project-name" placeholder="SpaceX" />
    </div>
    <div class="label-input-wrapper">
      <span>Minimum votes</span>
      <input type="number" id="create-project-votes" placeholder="3" />
    </div>
    <div class="label-input-wrapper">
      <span>ERC-20 reward</span>
      <input type="text" id="create-project-token" placeholder="0x..." />
    </div>
    <button class="primary-button" @click="createProject" style="float: right">create</button>
  </Modal>
</template>

<script>
import { getProjects, createProject } from "@/services/web3"
import Loader from "@/components/Loader"
import Modal from "@/components/Modal"

export default {
  components: { Loader, Modal },
  data: function () {
    return {
      projects: null,
      createProjectModal: false
    }
  },
  mounted: function () {
    getProjects().then(projects => this.projects = projects).catch(console.error);
  },
  methods: {
    redirectProject: function (address) {
      this.$router.push(`/project/${address}`);
    },
    createProject: function () {
      const name = document.querySelector("#create-project-name").value;
      const votes = document.querySelector("#create-project-votes").value;
      const token = document.querySelector("#create-project-token").value;
      if (!name || !votes || !token) {
        return this.$toast.error("Missing input");
      }
      createProject(name, votes, token)
      .then(() => {
        this.$toast.success(`Successfully created ${name}`);
        this.createProjectModal = false;
      })
      .catch(err => this.$toast.error(`Cannot create project: ${err}`))
    }
  }
}
</script>

<style lang="scss" scoped>
#projects-loading-overlay {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  width: 100%;
}

#projects-listing {
  display: flex;
  flex-wrap: wrap;
}

.projects-listing-item {
  box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px;
  margin: 20px;
  border-radius: 10px;
  cursor: pointer;
  width: 200px;
  height: 150px;
  position: relative;
  overflow: hidden;

  h3 {
    // font-weight: 300;
    margin: 20px;
  }

  img {
    width: 100%;
    height: auto;
    position: absolute;
    bottom: 0;
  }
}
</style>
