import Vue from 'vue'
import Vuex from 'vuex'

import axios from 'axios'
axios.defaults.baseURL = 'http://10.74.54.203:8000'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        rawData: [],
        visData: [],
        isLoading: false
    },
    getters: {
        rawData (state) {
            return state.rawData
        },
        visData (state) {
            return state.visData
        },
        isLoading (state) {
            return state.isLoading
        }
    },
    mutations: {
        getRawData (state, payload) {
            state.rawData = payload
        },
        updateVisData (state) {
            state.visData = state.rawData.sort(() => .5 - Math.random()).slice(0, 10)
        },
        toggleIsLoading (state) {
            state.isLoading = !state.isLoading
        }
    },
    actions: {
        getRawData ({ commit }) {
            commit('toggleIsLoading')

            axios.post('/hdata')
                .then(res => {
                    commit('getRawData', res.data)
                    commit('updateVisData')
                    commit('toggleIsLoading')
                })
                .catch(err => {
                    console.log('error')
                    commit('toggleIsLoading')
                    console.log(err)
                })
        }
    }
})