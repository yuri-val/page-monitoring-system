<template>
  <div id="site">
    <breadcrumbs :cumbs="cumbs" v-if='!loading'/>
    <h1>{{site.site_url}}</h1>
    <sui-dimmer :active="loading" inverted>
      <sui-loader />
    </sui-dimmer>
    <sui-grid :columns="4">
      <sui-grid-row>
        <sui-grid-column v-for="(article) in articles" :key="article.id">
          <sui-card class="fluid">
            <sui-card-content>
              <sui-card-header>{{article.title}}</sui-card-header>
              <sui-card-meta>
                <span>{{article.article_url}}</span>
              </sui-card-meta>
              <span slot="right">
                <sui-icon name="copy outline" /> {{article.versions_size}} versions
              </span>
            </sui-card-content>
            <router-link tag="sui-button" attached="bottom" :to="`/articles/${article.id}`">
              <sui-icon name="edit outline" /> Open
            </router-link>
          </sui-card>
        </sui-grid-column>
      </sui-grid-row>
    </sui-grid>
  </div>
     
</template>

<script>
import { show } from "@/resources/sites";
import { siteArticles } from "@/resources/articles";
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
  data() {
    return {
      id: this.$route.params.id,
      site: {},
      articles: [],
      loading: true
    };
  },
  components: {
    Breadcrumbs  
  },
  created() {
    show(this.id)
      .then(response => {
        this.site = response.data;
        siteArticles(this.id)
          .then(response => {
            this.articles = response.data;
            this.loading = false;
          })
          .catch(e => {
            this.errors.push(e);
          });
      })
      .catch(e => {
        this.errors.push(e);
      });
  },
  computed: {
    cumbs() {
      return [
        { to: "/sites"                        , title: 'Sites' },
        { to: `/sites/${this.site.id}`, title: this.site.site_url }
      ]
    }
  }
};
</script>
