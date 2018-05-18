import Vue from 'vue'
import Vuex from 'vuex'

import axios from 'axios'
axios.defaults.baseURL = 'http://10.74.54.203:8000'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        rawData: [],
        visData: []
    },
    getters: {
        rawData (state) {
            return state.rawData
        },
        visData (state) {
            return state.visData
        }
    },
    mutations: {
        getRawData (state, payload) {
            state.rawData = payload
        },
        updateVisData (state) {
            state.visData = state.rawData.sort(() => .5 - Math.random()).slice(0, 10)
        }
    },
    actions: {
        getRawData ({ commit }) {
            axios.post('/hdata')
                .then(res => {
                    commit('getRawData', res.data)
                })
                .catch(err => {
                    console.log('error')
                    console.log(err)
                })
        }
    }
})