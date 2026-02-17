<template>
  <div class="page-all-products">
    <div class="columns is-multiline">
      <div class="column is-12">
        <h2 class="is-size-2 has-text-centered">All Products</h2>
      </div>

      <div class="column is-12" v-if="products.length">
        <table class="table is-fullwidth is-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Category</th>
              <th>Price</th>
              <th>Storage (GB)</th>
              <th>RAM (GB)</th>
              <th>CPU Cores</th>
              <th>Description</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in products" :key="product.id">
              <td>{{ product.id }}</td>
              <td>{{ product.name }}</td>
              <td>{{ product.category_name }}</td>
              <td>${{ product.price }}</td>
              <td>{{ product.storage_gb || '-' }}</td>
              <td>{{ product.ram_gb || '-' }}</td>
              <td>{{ product.cpu_cores || '-' }}</td>
              <td>{{ product.description ? product.description.substring(0, 100) + '...' : '-' }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="column is-12" v-else>
        <p class="has-text-centered">No products found.</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AllProducts',
  data() {
    return {
      products: []
    }
  },
  mounted() {
    this.getProducts()
  },
  methods: {
    async getProducts() {
      await axios
        .get('/api/v1/products/all/')
        .then(response => {
          this.products = response.data
        })
        .catch(error => {
          console.log(error)
        })
    }
  }
}
</script>
