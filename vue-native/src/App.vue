<template>
  <v-app>
    <v-toolbar dense color="light-blue" dark fixed app>
      <v-toolbar-title>
          Vue - native
      </v-toolbar-title>
    </v-toolbar>
    <v-content>
      <p>{{ visData }}</p>
      <v-btn @click="vis">update</v-btn>
      <app-data-table></app-data-table>
      <app-plotly></app-plotly>
    </v-content>    
  </v-app>
</template>

<script>
import DataTable from './components/DataTable.vue'
import Plotly from './components/Plotly.vue'

export default {
  components: {
    appDataTable: DataTable,
    appPlotly: Plotly
  },
  computed: {
    visData() {
      return this.$store.getters['visData']
    }
  },
  methods: {
    vis() {
      this.$store.commit('updateVisData')
      console.log(this.visData)
    }
  },
  created () {
    this.$store.dispatch('getRawData')
  }

}
</script>

<style>

</style>
