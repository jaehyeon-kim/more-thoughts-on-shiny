<template>
  <v-data-table
    :headers="headers"
    :items="visData"
    class="elevation-1"
  >
    <template slot="items" slot-scope="props">
      <td class="text-xs-right">{{ props.item.SepalLength }}</td>
      <td class="text-xs-right">{{ props.item.SepalWidth }}</td>
      <td class="text-xs-right">{{ props.item.PetalLength }}</td>
      <td class="text-xs-right">{{ props.item.PetalWidth }}</td>
      <td class="text-xs-right">{{ props.item.Species }}</td>
    </template>
    <template slot="pageText" slot-scope="props">
        Lignes {{ props.pageStart }} - {{ props.pageStop }} of {{ props.itemsLength }}
    </template>
  </v-data-table>
</template>

<script>
export default {
    data () {
        return {
            headers: [
                { text: 'Sepal Length', value: 'SepalLength'},
                { text: 'Sepal Width', value: 'SepalWidth'},
                { text: 'Petal Length', value: 'PetalLength'},
                { text: 'Petal Width', value: 'PetalWidth'},
                { text: 'Species', value: 'Species'}
            ]
        }
    },
    computed: {
        visData() {
            return this.$store.getters['visData']
        }
    }
}
</script>
