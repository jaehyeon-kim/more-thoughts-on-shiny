<template>
    <vue-plotly :data="data" :layout="layout" :options="options"/>
</template>

<script>
import VuePlotly from '@statnett/vue-plotly'

export default {
  components: {
    VuePlotly
  },
  data: function () {
    return {
        layout: {
            autosize: true,
            scene:{
                aspectmode: 'manual',
                aspectratio: {
                    x: 1, y: 0.7, z: 1,
                },
                xaxis: {
                    title: 'Sepal Length'
                },
                yaxis: {
                    title: 'Sepal Width'
                },
                zaxis: {
                    title: 'Petal Length'
                }
            }
        },
        options: {}
    }
  },
  computed: {
      visData() {
          return this.$store.getters['visData']
      },
      data() {
          return this.getData()
      }
  },
  methods: {
    filterData(col, species) {
        return this.visData.filter(x => x['Species'] === species)
            .map(x => x[col])
    },
    getData() {
        return [
            {
                type: 'scatter3d',
                opacity:0.8,
                mode: 'markers',
                name: 'setosa',
                marker: {
                    color:'rgba(102,194,165,1)',
                    line: {
                        color: 'transparent'
                    }
                },                
                x: this.filterData('SepalLength', 'setosa'),
                y: this.filterData('SepalWidth', 'setosa'),
                z: this.filterData('PetalLength', 'setosa')
            },
            {
                type: 'scatter3d',
                opacity:0.8,
                mode: 'markers',
                name: 'versicolor',
                marker: {
                    color:'rgba(252,141,98,1)',
                    line: {
                        color: 'transparent'
                    }
                },                
                x: this.filterData('SepalLength', 'versicolor'),
                y: this.filterData('SepalWidth', 'versicolor'),
                z: this.filterData('PetalLength', 'versicolor')
            },
            {
                type: 'scatter3d',
                opacity:0.8,
                mode: 'markers',
                name: 'virginica',
                marker: {
                    color:'rgba(141,160,203,1)',
                    line: {
                        color: 'transparent'
                    }
                },                
                x: this.filterData('SepalLength', 'virginica'),
                y: this.filterData('SepalWidth', 'virginica'),
                z: this.filterData('PetalLength', 'virginica')
            }
        ]
    }
  }
}
</script>
