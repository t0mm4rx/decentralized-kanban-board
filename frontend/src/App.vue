<template>
  <router-view/>
</template>

<style lang="scss">
@import url('https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;500&display=swap');

body, html {
  width: 100%;
  margin: 0;
  padding: 0;
  font-family: "Open Sans";
  font-weight: 300;
  color: #333;
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

  input, textarea {
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
  border-radius: 10px;
  cursor: pointer;
}

.primary-text {
  color: rgb(94, 99, 223);
  font-weight: 500;
  cursor: pointer;
}
</style>
