<template>
  <h2>Projects</h2>
  <div v-if="projects !== null" id="projects-listing">
    <div
    v-for="project in projects"
    :key="project.name"
    class="projects-listing-item"
    @click="() => redirectProject(project.address)">
      <h3>{{ project.name }}</h3>
    </div>
    <div class="projects-listing-item">
      Create a new project
    </div>
  </div>
  <div v-if="projects === null" id="projects-loading-overlay">
    <Loader />
  </div>
</template>

<script>
import { getProjects } from "@/services/web3"
import Loader from "@/components/Loader"

export default {
  components: { Loader },
  data: function () {
    return {
      projects: null
    }
  },
  mounted: function () {
    getProjects().then(projects => this.projects = projects).catch(console.error);
  },
  methods: {
    redirectProject: function (address) {
      this.$router.push(`/project/${address}`);
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
  padding: 20px;
  border-radius: 10px;
  cursor: pointer;
  width: 150px;
  height: 150px;

  h3 {
    font-weight: 300;
    margin: 0;
  }
}
</style>
