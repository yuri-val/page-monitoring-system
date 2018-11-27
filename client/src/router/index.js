import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Sites from '@/components/Sites/List'
import Site from '@/components/Sites/Form'
import Article from '@/components/Articles/Form'
import Compare from '@/components/Vesions/Compare'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [{
    path: '/',
    name: 'HelloWorld',
    component: HelloWorld
  }, {
    path: '/sites',
    name: 'Sites',
    component: Sites
  }, {
    path: '/sites/:id',
    name: 'Site',
    component: Site
  }, {
    path: '/articles/:id',
    name: 'Article',
    component: Article
  }, {
    path: '/compare/:id/:anotherId',
    name: 'Compare',
    component: Compare
  }]
})
