<template>
  <div id="sites">
    <breadcrumbs :cumbs="cumbs" v-if='!loading'/>
    <vs-row>
      <vs-col v-for="(site) in sites" :key="site.id" vs-w="4">
        <vs-card actionable class="fluid">
          <div slot="header">
            <h3>{{site.site_url}}</h3>
          </div>
          <div>
            <vs-row vs-justify="flex-end">
              <vs-icon icon="library_books" /> {{site.atricles_size}} articles
            </vs-row>
          </div>
          <div slot="footer">
            <vs-row vs-justify="flex-end">
              <router-link :to="`/sites/${site.id}`">
                <vs-button color="success" type="gradient" icon="search">Open</vs-button>
              </router-link>
            </vs-row>
          </div>
        </vs-card>
      </vs-col>
    </vs-row>
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
    this.$vs.loading({type: 'point'});
    index()
      .then(response => {
        this.sites = response.data;
        this.$vs.loading.close();
      })
      .catch(e => {
        this.errors.push(...e);
      });
  },
  computed: {
    cumbs() {
      return [
        { to: '/sites', title: 'Sites' }
      ]
    }
  }
};
</script>
