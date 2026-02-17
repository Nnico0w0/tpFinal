<template>
  <div class="page-all-users">
    <div class="columns is-multiline">
      <div class="column is-12">
        <h2 class="is-size-2 has-text-centered">All Users</h2>
      </div>

      <div class="column is-12" v-if="users.length">
        <table class="table is-fullwidth is-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Username</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Role</th>
              <th>Date Joined</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id">
              <td>{{ user.id }}</td>
              <td>{{ user.username }}</td>
              <td>{{ user.person ? user.person.first_name : '-' }}</td>
              <td>{{ user.person ? user.person.last_name : '-' }}</td>
              <td>{{ user.person ? user.person.email : '-' }}</td>
              <td>{{ user.person ? user.person.phone : '-' }}</td>
              <td>{{ user.role || '-' }}</td>
              <td>{{ formatDate(user.date_joined) }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="column is-12" v-else>
        <p class="has-text-centered">No users found.</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AllUsers',
  data() {
    return {
      users: []
    }
  },
  mounted() {
    this.getUsers()
  },
  methods: {
    async getUsers() {
      await axios
        .get('/api/v1/public/users/list/')
        .then(response => {
          this.users = response.data
        })
        .catch(error => {
          console.log(error)
        })
    },
    formatDate(dateString) {
      if (!dateString) return '-'
      const date = new Date(dateString)
      return date.toLocaleDateString()
    }
  }
}
</script>
