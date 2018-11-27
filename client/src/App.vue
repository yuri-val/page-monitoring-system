<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
import "semantic-ui-css/semantic.min.css";

export default {
  name: "App"
};
</script>

<style>
body {
  background: #C6FFDD;  /* fallback for old browsers */
  background: -webkit-linear-gradient(to right, #f7797d, #FBD786, #C6FFDD);  /* Chrome 10-25, Safari 5.1-6 */
  background: linear-gradient(to right, #f7797d, #FBD786, #C6FFDD); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
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
