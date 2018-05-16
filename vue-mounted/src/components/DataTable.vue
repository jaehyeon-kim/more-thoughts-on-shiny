<template>
    <v-container fluid>
        <v-layout row wrap>
            <v-flex xs1 sm2 md2>
                <div style="height: 400px">
                    <v-btn 
                        @click="update"
                        color="primary"
                    >update table</v-btn>
                </div>
            </v-flex>
            <v-flex xs10 sm10 md10>
                <div style="height: 400px">
                  <div id="htmlwidget_container_dt_out">
                    <div id="htmlwidget_dt_out" style="width:100%;height:100%;" :class="cls"></div>
                  </div>
                  <script type="application/htmlwidget-sizing" data-for="htmlwidget_dt_out">{"browser":{"width":"100%","height":400,"padding":40,"fill":true}}</script>
                  <div>{{ dat }}</div>
                </div>
            </v-flex>
        </v-layout>
    </v-container>
</template>

<script>
import axios from 'axios'

export default {
    data: () => ({
        dat: null,
        cls: 'datatables html-widget'
    }),
    methods: {
        update() {
            let params = { element_id: 'dt_out', type: 'json' }
            axios.post('http://10.74.54.203:8000/widget', params)
            .then(res => {
                console.log(res.data)
            })
            .catch(err => {
                console.log(err)
            })
            // $('htmlwidget_dt_out').removeClass("html-widget-static-bound")
            // window.HTMLWidgets.staticRender()
        }
    }
}
</script>
