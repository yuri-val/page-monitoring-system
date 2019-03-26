<template>
  <div>
    <vs-button color="success" :type="cumbs.length === (index+1) ? 'relief' : 'gradient'" v-for="(cumb, index) in cumbs" :key="index">
      <router-link :to="cumb.to">{{cumb.title}}</router-link>
    </vs-button>
  </div>
</template>

<script>
export default {
  name: "breadcrumbs",
  props: ['cumbs'],
  created() {
    this.$emit('set-title', this.cumbs[this.cumbs.length - 1].title);
  }
}
</script>

