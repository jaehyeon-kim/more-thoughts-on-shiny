<template>
  <v-app>
    <v-toolbar dense color="light-blue" dark fixed app>
      <v-toolbar-title>
          Vue - htmlwidgets
      </v-toolbar-title>
    </v-toolbar>
    <v-content>
      <app-data-table></app-data-table>
      <app-high-chart></app-high-chart>
      <app-plotly></app-plotly>
    </v-content>    
  </v-app>
</template>

<script>
import DataTable from './components/DataTable.vue'
import HighChart from './components/HighChart.vue'
import Plotly from './components/Plotly.vue'

export default {
    components: {
      appDataTable: DataTable,
      appHighChart: HighChart,
      appPlotly: Plotly
    }
}
</script>