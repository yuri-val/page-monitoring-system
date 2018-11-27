<template>
  <div id="sites">
    <breadcrumbs :cumbs="cumbs" v-if='!loading'/>
    <sui-dimmer :active="loading" inverted>
      <sui-loader />
    </sui-dimmer>
    <sui-grid :columns="3">
      <sui-grid-row>
        <sui-grid-column v-for="(site) in sites" :key="site.id">
          <sui-card class="fluid">
            <sui-card-content>
              <sui-card-header>{{site.site_url}}</sui-card-header>
              <span slot="right">
                <sui-icon name="file alternate outline" /> {{site.atricles_size}} articles
              </span>
            </sui-card-content>
            <router-link tag="sui-button" attached="bottom" :to="`/sites/${site.id}`">
              <sui-icon name="edit outline" /> Open
            </router-link>
          </sui-card>
        </sui-grid-column>
      </sui-grid-row>
    </sui-grid>
  </div>
</template>

<script>
import { index } from "@/resources/sites";
import Breadcrumbs from '@/components/Breadcrumbs'

export default {
  data() {
    return {
      sites: [],
      errors: [],
      loading: true
    };
  },
  components: {
    Breadcrumbs  
  },
  created() {
    index()
      .then(response => {
        this.sites = response.data;
        this.loading = false;
      })
      .catch(e => {
        this.errors.push(...e);
      });
  },
  computed: {
    cumbs() {
      return [
        { to: "/sites", title: 'Sites' }
      ]
    }
  }
};
</script>
