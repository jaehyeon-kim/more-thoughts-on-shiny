<template>
    <v-container fluid>
        <v-layout row wrap>
            <v-flex xs1 sm2 md2>
                <div style="height: 400px;">
                    <v-btn 
                        @click="update"
                        color="primary"
                    >update highchart</v-btn>
                    <div v-if="isLoading" style="margin: 0 auto; width: 50%;">
                        <v-progress-circular indeterminate color="info"></v-progress-circular>
                    </div>
                </div>
            </v-flex>
            <v-flex xs10 sm10 md10>
                <div style="height: 400px">
                    <div v-if="!isLoading" v-html="dat"></div>
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
        isLoading: false
    }),
    methods: {
        update() {
            this.dat = null
            this.isLoading = true

            let params = { element_id: 'highchart_out', type: 'html' }
            axios.post('http://10.74.54.203:8000/widget', params)
                .then(res => {
                    console.log(res.data)
                    this.dat = res.data
                    setTimeout(function() {
                        window.HTMLWidgets.staticRender()
                    }, 500)
                    this.isLoading = false             
                })
                .catch(err => {
                    this.isLoading = false
                    console.log(err)
                })
        }
    }
}
</script>