<template>
    <div>
        <highcharts :options="chartOptions"></highcharts>        
    </div>    
</template>
<script>

import { Chart } from 'highcharts-vue'

export default {
    components: {
        highcharts: Chart
    },
    computed: {
        visData() {
            return this.$store.getters['visData']
        },
        chartOptions() {
            return {
                title: {
                    text: null
                },
                xAxis: {
                    title: {
                        text: 'Sepal Length'
                    }
                },
                yAxis: {
                    title: {
                        text: 'Sepal Width'
                    }
                },
                series: [
                    {
                        name: 'setosa',
                        type: 'scatter',
                        data: this.filterData('setosa')
                    },
                    {
                        name: 'versicolor',
                        type: 'scatter',
                        data: this.filterData('versicolor')
                    },
                    {
                        name: 'virginica',
                        type: 'scatter',
                        data: this.filterData('virginica')
                    }
                ]
            }
        }
    },
    methods: {
        filterData(species) {
            return this.visData
                        .filter(x => x['Species'] === species)
                        .map(x => [x['SepalLength'], x['SepalWidth']])
        }
    }
}
</script>
