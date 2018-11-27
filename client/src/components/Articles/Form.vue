<template>
  <div id="article">
    <breadcrumbs :cumbs="cumbs" v-if='!loading'/>
    <sui-dimmer :active="loading" inverted>
      <sui-loader />
    </sui-dimmer>
    <sui-grid :columns="2">
      <sui-grid-row>
        <sui-grid-column :width="12">
          <h1>{{article.title}}</h1>
          <h3>{{article.article_url}}</h3>
        </sui-grid-column>
        <sui-grid-column :width="4">
          <sui-card  class="fluid">
            <sui-card-content>
              <sui-card-header>Compare</sui-card-header>
            </sui-card-content>
            <sui-card-content extra>
              <sui-button-group attached="top">
                <sui-button basic positive :content="compare[0]"/>
                <sui-button-or text="vs" />
                <sui-button basic negative :content="compare[1]"/>
              </sui-button-group>
            </sui-card-content>
            <router-link tag="sui-button" attached="bottom" :to="compareLink" :disabled="compare.length !== 2">
              <sui-icon name="balance scale" /> Compare
            </router-link>
          </sui-card>
        </sui-grid-column>
      </sui-grid-row>
    </sui-grid>
    <sui-dimmer :active="loading" inverted>
      <sui-loader />
    </sui-dimmer>
    <sui-grid :columns="5">
      <sui-grid-row>
        <sui-grid-column v-for="(version) in versions" :key="version.id">
          <sui-card :class="version.id === article.current_version.id ? 'current' : ''">
            <sui-card-content>
              <sui-card-header>{{version.version}}</sui-card-header>
              <sui-card-meta>
                <span>{{version.plain_text}}</span>
              </sui-card-meta>
            </sui-card-content>
            <sui-card-content extra>
                <sui-checkbox 
                  label="To compare" 
                  toggle v-model="compare" 
                  :id="version.id" 
                  :value="`${version.version}`" 
                  :disabled='!allowCompare && !compare.includes(`${version.version}`)'
                />
            </sui-card-content>
          </sui-card>
        </sui-grid-column>
      </sui-grid-row>
    </sui-grid>
    <sui-segment>
      <div v-html="currentVersion.text" />
    </sui-segment>
  </div>

</template>

<script>
import { show } from "@/resources/articles";
import { text, articleVersions } from "@/resources/versions";
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
  data() {
    return {
      id: this.$route.params.id,
      article: {},
      versions: [],
      currentVersion: {},
      loading: true,
      compare: []
    };
  },
  components: {
    Breadcrumbs  
  },
  methods: {
    
  },
  created() {
    show(this.id)
      .then(response => {
        this.article = response.data;
        articleVersions(this.id)
          .then(response => {
            this.versions = response.data;
            if(this.article.current_version) {
              text(this.article.current_version.id, 'html_text')
                .then(response => {
                  this.currentVersion = response.data;
                })
                .catch(e => {
                  this.errors.push(e);
                });
            }
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
    allowCompare() {
      return this.compare.length < 2
    },
    compareLink() {
      if(this.compare.length !== 2) return '';
      const v1 = this.versions.find((item) => item.version == this.compare[0])
      const v2 = this.versions.find((item) => item.version == this.compare[1])
      return `/compare/${v1.id}/${v2.id}`   
    },
    cumbs() {
      return [
        { to: "/sites"                        , title: 'Sites' },
        { to: `/sites/${this.article.site.id}`, title: this.article.site.site_url },
        { to: `/articles/${this.article.id}`  , title: this.article.title }
      ]
    }
  }
};
</script>

<style scoped>
.current {
  background-color: rgb(183, 248, 248)
}
</style>
