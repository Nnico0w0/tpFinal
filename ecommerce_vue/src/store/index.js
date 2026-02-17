import { createStore } from 'vuex'

export default createStore({
  state: {
    cart: {
      items: []
    },
    isAuthenticated: false,
    token: '',
    isLoading: false,
    isAdmin: false,
    username: ''
  },
  mutations: {

    initiallizeStore(state) {
      // cart
      if(localStorage.getItem('cart')) {
        state.cart = JSON.parse(localStorage.getItem('cart'))
      } else {
        localStorage.setItem('cart', JSON.stringify(state.cart))
      }

      // login
      if(localStorage.getItem('token')) {
        state.token = localStorage.getItem('token')
        state.isAuthenticated = true
        state.username = localStorage.getItem('username') || ''
        state.isAdmin = localStorage.getItem('isAdmin') === 'true'
      } else {
        state.token = ''
        state.isAuthenticated = false
        state.isAdmin = false
        state.username = ''
      }

    },

    addToCart(state, item) {
      const exists = state.cart.items.filter( i => i.product.id === item.product.id)
      if(exists.length) {
        exists[0].quantity = parseInt(exists[0].quantity) + parseInt(item.quantity)
      } else {
        state.cart.items.push(item)
      }

      localStorage.setItem('cart', JSON.stringify(state.cart))
    },
    setIsLoading(state, status) {
      state.isLoading = status
    },

    setToken(state, token) {
      state.token = token
      state.isAuthenticated = true
    },
    setUsername(state, username) {
      state.username = username
    },
    setIsAdmin(state, isAdmin) {
      state.isAdmin = isAdmin
    },
    removeToken(state, token) {
      state.token = ''
      state.isAuthenticated = false
      state.isAdmin = false
      state.username = ''
    },
    clearCart(state) {
      state.cart = { items: []}
      localStorage.setItem('cart', JSON.stringify(state.cart))
    }
  },
  actions: {
  },
  modules: {
  }
})
