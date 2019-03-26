<template>
  <div id="article">
    <breadcrumbs :cumbs="cumbs" v-if='!loading'/>
    <container :title="article.title">
      <vs-row slot="paginator">
        <vs-card actionable >
          <div slot="header">
            <h3>Compare</h3>
          </div>
          <div>
            <vs-row vs-justify="space-between" vs-w="12">
              <vs-col vs-w="5">
                <vs-button disbled color="success" type="border" class="fit">{{compare[0]}}</vs-button>
              </vs-col>
              <vs-col vs-justify="center" vs-w="2">
                <vs-button disbled type="border" class="fit">VS</vs-button>
              </vs-col>
              <vs-col vs-w="5">
                <vs-button disbled color="danger" type="border" class="fit">{{compare[1]}}</vs-button>
              </vs-col>
            </vs-row>
          </div>
          <div slot="footer">
            <vs-row vs-justify="flex-end">
              <vs-button color="success" type="gradient" icon="compare" :to="compareLink" >Compare</vs-button>
            </vs-row>
          </div>
        </vs-card>
        <vs-pagination :total="paginator.total" v-model="paginator.page" :value="paginator.page" prev-icon="arrow_back" next-icon="arrow_forward" slot="paginator"></vs-pagination>
      </vs-row>
      <div slot="content">
        <vs-row slot="content">
          <vs-col v-for="(version) in versions" :key="version.id" vs-w="3" class="cardx" >
            <vs-card actionable fixedHeight :class="version.id === article.current_version.id ? 'current' : ''">
              <div slot="header">
                <h3>{{version.version}}</h3>
              </div>
              <div>
                <span>
                  {{version.plain_text}}
                </span>
              </div>
              <div slot="footer">
                <vs-row >
                  <vs-switch
                    label="To compare"
                    toggle v-model="compare"
                    :id="version.id"
                    :vs-value="`${version.version}`"
                    :disabled='!allowCompare && !compare.includes(`${version.version}`)'
                  >
                    <span slot="on">Comparing...</span>
                    <span slot="off">To compare</span>
                  </vs-switch>
                </vs-row>
              </div>
            </vs-card>
          </vs-col>
        </vs-row>
        <vs-row vs-justify="center" slot="content">
          <vs-col vs-w="12" >
            <vs-card>
              <div slot="header">
                <h2>Article content</h2>
              </div>
              <div>
                <div v-html="currentVersion.text"></div>
              </div>
            </vs-card>
          </vs-col>
        </vs-row>
      </div>
    </container>
  </div>

</template>

<script>
import { show } from "@/resources/articles";
import { text, articleVersions } from "@/resources/versions";
import Breadcrumbs from '@/components/Breadcrumbs'
import Container from '@/components/MainContainer'
import { PER_PAGE } from "@/utils/constants";

export default {
  data() {
    return {
      id: this.$route.params.id,
      article: {},
      versions: [],
      currentVersion: {},
      loading: true,
      compare: [],
      paginator: {
        total: 5,
        page: 1,
        perPage: 20
      }
    };
  },
  components: {
    Breadcrumbs,
    Container
  },
  methods: {

  },
  created() {
    this.$vs.loading({type: 'point'});
    show(this.id)
      .then(response => {
        this.article = response.data;
        articleVersions(this.id)
          .then(response => {
            this.versions = response.data;
            this.paginator.total = Math.ceil(response.headers['total'] / PER_PAGE);
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
            this.$vs.loading.close();
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
.fit {
  width: 100%;
}
.cardx {
  padding: 2px;
}
</style>
