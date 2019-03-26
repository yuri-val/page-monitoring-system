<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
export default {
  name: "App"
};
</script>

<style>
body {
  background: url(assets/background.jpg);  /* fallback for old browsers */
  background-repeat: no-repeat;
  background-attachment: fixed;
}

#app {
  padding: 20px;

}
.ui.grid > .row > .column {
  margin-top: 10px;
}
</style>
