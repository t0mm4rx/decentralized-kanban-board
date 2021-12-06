<template>
  <Overlay :open="!metamaskAvailable">
    <h2>Metamask is not available</h2>
  </Overlay>
  <Overlay :open="!connected">
    <h2>Please connect your Polygon wallet</h2>
  </Overlay>
  <router-view v-if="connected" />
</template>

<script>
import Overlay from "@/components/Overlay"
import { isConnected, connect } from "@/services/wallet"

export default {
  components: { Overlay },
  data: function () {
    return {
      metamaskAvailable: true,
      connected: false
    }
  },
  mounted: function () {
    isConnected().then(result => {
      this.connected = result;
      if (!result) {
        connect().then(() => {
          this.$toast.success("Connected!");
          this.connected = true;
        }).catch(this.$toast.error);
      }
    });
  }
}
</script>

<style lang="scss">
@import url("https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;500&display=swap");

body,
html {
  width: 100%;
  margin: 0;
  padding: 0;
  font-family: "Open Sans";
  font-weight: 300;
  color: #2d3748;
}

#app {
  width: 100%;
  height: 100%;
  box-sizing: border-box;
}

h1 {
  font-weight: 500;
  margin: 20px;
  font-size: 1.5em;
}

.label-input-wrapper {
  display: flex;
  flex-direction: column;
  margin: 10px 0px;

  input,
  textarea {
    padding: 10px;
    border-radius: 10px;
    border: 1px solid #ccc;
    font-family: "Open Sans";
  }
}

.primary-button {
  padding: 10px;
  border: none;
  background-color: rgb(94, 99, 223);
  color: white;
  border-radius: 5px;
  width: 100%;
  cursor: pointer;
}

.primary-text {
  color: #1a202c;
  font-weight: 500;
  cursor: pointer;
}

.input-button-row {
  margin-top: 10px;
  display: flex;

  > input {
    flex: 1;
    box-sizing: border-box;
  }

  button {
    margin-left: 10px;
  }
}
</style>
