<template>
    <v-container fluid>
        <v-layout row wrap>
            <v-flex xs1 sm2 md2>
                <div style="height: 400px">
                    <v-btn 
                        @click="update"
                        color="primary"
                    >update plotly</v-btn>
                </div>
            </v-flex>
            <v-flex xs10 sm10 md10>
                <div style="height: 400px">
                    <h1>Plotly</h1>
                </div>
            </v-flex>
        </v-layout>
    </v-container>
</template>

<script>
export default {
    methods: {
        update() {

        }
    }
}
</script>