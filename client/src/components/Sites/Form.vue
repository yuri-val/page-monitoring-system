<template>
  <div id="site">
    <breadcrumbs :cumbs="cumbs" v-if='!loading'/>
    <container :title="site.site_url">
    <!--<h1>{{site.site_url}}</h1>-->
      <!--<vs-pagination :total="total" v-model="page" slot="paginator"></vs-pagination>-->
      <vs-pagination :total="total" v-model="page" :value="page" prev-icon="arrow_back" next-icon="arrow_forward" slot="paginator"></vs-pagination>
      <vs-row vs-justify="center" slot="content">
        <vs-col v-for="(article) in articles" :key="article.id" vs-w="3" class="cardx" >
          <vs-card actionable>
            <div slot="header">
              <h3>{{article.title}}</h3>
            </div>
            <div>
              <span>
                {{article.article_url}}
              </span>
              <vs-row vs-justify="flex-end">
                <vs-icon :icon="`filter_${article.versions_size > 9 ? '9_plus' : article.versions_size}`" /> versions
              </vs-row>
            </div>
            <div slot="footer">
              <vs-row vs-justify="flex-end">
                <router-link :to="`/articles/${article.id}`">
                  <vs-button color="success" type="gradient" icon="search">Open</vs-button>
                </router-link>
              </vs-row>
            </div>
          </vs-card>
        </vs-col>
      </vs-row>
    </container>
  </div>

</template>

<script>
import { show } from "@/resources/sites";
import { siteArticles } from "@/resources/articles";
import Breadcrumbs from '@/components/Breadcrumbs'
import Container from '@/components/MainContainer'
import { PER_PAGE } from "@/utils/constants";


export default {
  data() {
    return {
      errors: [],
      id: this.$route.params.id,
      site: {},
      articles: [],
      loading: true,
      page: 1,
      perPage: 16,
      total: 22
    };
  },
  components: {
    Breadcrumbs,
    Container
  },
  created() {
    this.$vs.loading({type: 'point'});
    show(this.id)
      .then(response => {
        this.site = response.data;
        this.setArticles()
      })
      .catch(e => {
        this.errors.push(e);
      });
  },
  methods: {
    setArticles() {
      this.$vs.loading({type: 'point'});
      siteArticles(this.id, this.page)
        .then(response => {
          // debugger;
          this.articles = response.data;
          this.total = Math.ceil(response.headers['total'] / PER_PAGE);
          this.loading = false;
          this.$vs.loading.close();
        })
        .catch(e => {
          this.errors.push(...e);
        });
    }
  },
  computed: {
    cumbs() {
      return [
        { to: "/sites"                        , title: 'Sites' },
        { to: `/sites/${this.site.id}`, title: this.site.site_url }
      ]
    }
  },
  watch: {
    page() {
      console.log('page changed!');
      this.setArticles();
    }
  }
};
</script>

<style>
  .cardx {
    padding: 2px;
  }
</style>
