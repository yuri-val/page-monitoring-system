<template>
  <sui-button-group>
    <sui-button basic secondary v-for="(cumb, index) in cumbs" :key="index" :active="cumbs.length === (index+1)">
      <router-link :to="cumb.to">{{cumb.title}}</router-link>
    </sui-button>
  </sui-button-group>
</template>

<script>
export default {
  name: "breadcrumbs",
  props: ['cumbs']
}
</script>

