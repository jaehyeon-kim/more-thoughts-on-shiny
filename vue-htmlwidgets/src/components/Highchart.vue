<template>
    <v-layout>
        <v-flex xs12 sm6 offset-sm2>
            <v-card>
                <v-card-media height="400px">
                    <v-container>
                        <v-layout row wrap justify-center>
                            <div v-if="!isLoading" v-html="dat"></div>
                        </v-layout>
                    </v-container>                    
                </v-card-media>
                <v-card-actions>
                    <v-container>
                        <v-layout row wrap justify-center>                        
                            <v-btn 
                                @click="update"
                                color="primary"
                            >update table</v-btn>
                            <div v-if="isLoading">
                                <v-progress-circular indeterminate color="info"></v-progress-circular>
                            </div>                        
                        </v-layout>
                    </v-container>
                </v-card-actions>
            </v-card>
        </v-flex>
    </v-layout>
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
                    this.dat = res.data.replace('width:100%;', 'width:100%')
                    console.log(this.dat)
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