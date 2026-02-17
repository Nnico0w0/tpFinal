<template>
  <div class="page-all-orders">
    <div class="columns is-multiline">
      <div class="column is-12">
        <h2 class="is-size-2 has-text-centered">All Orders</h2>
      </div>

      <div class="column is-12" v-if="orders.length">
        <div class="box" v-for="order in orders" :key="order.id">
          <h3 class="is-size-4">Order #{{ order.id }}</h3>
          <p><strong>Customer:</strong> {{ order.first_name }} {{ order.last_name }}</p>
          <p><strong>Email:</strong> {{ order.email }}</p>
          <p><strong>Phone:</strong> {{ order.phone }}</p>
          <p><strong>Address:</strong> {{ order.address }}, {{ order.place }}, {{ order.zipcode }}</p>
          <p><strong>Total:</strong> ${{ order.paid_amount }}</p>
          <p><strong>Status:</strong> {{ order.status }}</p>
          <p><strong>Date:</strong> {{ formatDate(order.created_at) }}</p>
          
          <div v-if="order.items && order.items.length" class="mt-4">
            <h4 class="is-size-5">Items:</h4>
            <table class="table is-fullwidth">
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Quantity</th>
                  <th>Price</th>
                  <th>Billing Cycle</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in order.items" :key="index">
                  <td>{{ item.product ? item.product.name : 'N/A' }}</td>
                  <td>{{ item.quantity }}</td>
                  <td>${{ item.price }}</td>
                  <td>{{ item.billing_cycle_months }} months</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="column is-12" v-else>
        <p class="has-text-centered">No orders found.</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AllOrders',
  data() {
    return {
      orders: []
    }
  },
  mounted() {
    this.getOrders()
  },
  methods: {
    async getOrders() {
      await axios
        .get('/api/v1/orders/all/')
        .then(response => {
          this.orders = response.data
        })
        .catch(error => {
          console.log(error)
        })
    },
    formatDate(dateString) {
      if (!dateString) return '-'
      const date = new Date(dateString)
      return date.toLocaleString()
    }
  }
}
</script>
