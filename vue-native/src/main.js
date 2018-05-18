import Vue from 'vue'
import App from './App.vue'

import store from './store'

import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.css'
Vue.use(Vuetify)

new Vue({
  el: '#app',
  store,
  render: h => h(App)
})
