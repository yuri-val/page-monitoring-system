<template>
  <div id="compare">
    <breadcrumbs :cumbs="cumbs" v-if='!loading'/>
    <sui-dimmer :active="loading" inverted>
      <sui-loader />
    </sui-dimmer>
    <sui-segment>
      <div v-html="diff" />
    </sui-segment>
  </div>

</template>

<script>
import { show, compare } from "@/resources/versions";
import { show as showSite } from "@/resources/sites";
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
  data() {
    return {
      id: this.$route.params.id,
      anotherId: this.$route.params.anotherId,
      article: {},
      site: {},
      diff: '',
      loading: true
    };
  },
  components: {
    Breadcrumbs  
  },
  methods: {

  },
  created() {
    const component = this;
    compare(component.id, component.anotherId)
      .then(response => {
        component.diff = response.data;
        show(component.id)
          .then(response => {
            component.article = response.data.article;
            showSite(component.article.site_id)
              .then(response => {
                component.site = response.data;
                component.loading = false;
              });
          });
      })
      .catch(e => {
        component.errors.push(e);
      });
  },
  computed: {
    cumbs() {
      return [
        { to: "/sites"                               , title: 'Sites' },
        { to: `/sites/${this.site.id}`               , title: this.site.site_url },
        { to: `/articles/${this.article.id}`         , title: this.article.title },
        { to: `/compare/${this.id}/${this.anotherId}`, title: 'Comparing' }
      ]
    }
  }
};
</script>
