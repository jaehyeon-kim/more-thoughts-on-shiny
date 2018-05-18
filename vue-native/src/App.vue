<template>
  <v-app>
    <v-toolbar dense color="light-blue" dark fixed app>
      <v-toolbar-title>
          Vue - native
      </v-toolbar-title>
    </v-toolbar>
    <v-content>      
      <div v-if="isLoading" class="centered">
          <v-progress-circular 
            indeterminate color="info"
            :size="100"
            :width="10"
          ></v-progress-circular>
      </div>
      <div v-else>
        <v-btn @click="update">update data</v-btn>
        <v-container fluid>
          <v-layout row wrap>
            <v-flex xs12 sm12 md6>
              <div style="display: inline-block;">
                <app-data-table></app-data-table>
              </div>            
            </v-flex>
            <v-flex xs12 sm12 md6>
              <div style="display: inline-block;">
                <app-highchart></app-highchart>
              </div>            
            </v-flex>
            <v-flex xs12 sm12 md6>
              <div style="display: inline-block;">
                <app-plotly></app-plotly>
              </div>            
            </v-flex>
          </v-layout>
        </v-container>      
      </div>
    </v-content>    
  </v-app>
</template>

<script>
import DataTable from './components/DataTable.vue'
import Highchart from './components/HighChart.vue'
import Plotly from './components/Plotly.vue'

export default {
  components: {
    appDataTable: DataTable,
    appHighchart: Highchart,
    appPlotly: Plotly
  },
  computed: {
    visData() {
      return this.$store.getters['visData']
    },
    isLoading() {
      return this.$store.getters['isLoading']
    }
  },
  methods: {
    update() {
      this.$store.commit('updateVisData')
    }
  },
  created () {
    this.$store.dispatch('getRawData')
  }
}
</script>

<style scoped>
.centered {
  position: fixed; /* or absolute */
  top: 50%;
  left: 50%;
}
</style>
