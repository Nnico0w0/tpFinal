<template>
  <div class="wrapper">
    
    <!-- navbar -->
    <nav class="navbar" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <a class="navbar-item" href="/">
          <img src="@/assets/logo.png" alt="buildServe" style="max-height: 50px; width: auto;">
          <span class="logo-text">buildServe</span>
        </a>

        <a role="button" class="navbar-burger" aria-label="menu" 
        aria-expanded="false" data-target="navbarBasicExample" @click="showMobileMenu = !showMobileMenu">
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>

      </div>

      <div id="navbarBasicExample" class="navbar-menu" v-bind:class="{'is-active': showMobileMenu}">
        
        <div class="navbar-start">
          <router-link to="/" class="navbar-item">Inicio</router-link>
          <router-link to="/services" class="navbar-item">Todos los Servicios</router-link>
        </div>

        <div class="navbar-end">
          
          <div class="navbar-item">
            <div class="buttons">

              <template v-if="$store.state.isAuthenticated">
                  <router-link to="/my-services" class="button is-info">Mis Servicios</router-link>
                  <router-link to="/my-account" class="button is-light">Mi Cuenta</router-link>
                  <a v-if="$store.state.isAdmin" href="http://localhost:8000/admin/" target="_blank" class="button is-warning">Admin Panel</a>
              </template>

              <template v-else>
                <router-link to="/sign-up" class="button is-primary">Registrarse</router-link>
                <router-link to="/log-in" class="button is-info">Iniciar Sesión</router-link>
              </template>
              
              <router-link to="/cart" class="button is-success">
                <span class="icon">
                  <i class="fas fa-shopping-cart"></i> ({{ cartTotalLength }})
                </span>
              </router-link>

            </div>
          </div>
        </div>

      </div>
    </nav>

    <div class="is-loading-bar has-text-centered" v-bind:class="{'is-loading': $store.state.isLoading}">
      <div class="lds-dual-right"></div>
    </div>

    <!-- body -->
    <section class="section">
      <router-view/>
    </section>

    <!-- footer -->
    <footer class="footer">
      <p class="has-text-centered">Copyright (c) 2026 buildServe - All rights reserved</p>
    </footer>

  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      showMobileMenu: false,
      cart: {
        items: []
      }
    }
  },
  beforeCreate() {
    // initialize
    this.$store.commit('initiallizeStore')
    
    const token = this.$store.state.token

    if(token) {
      axios.defaults.headers.common['Authorization'] = "Token " + token
    } else {
      axios.defaults.headers.common['Authorization'] = ''
    }

  },
  mounted() {
      this.cart = this.$store.state.cart
  },
  computed: {
    cartTotalLength() {
      let totalLength = 0
      for (let i = 0; i < this.cart.items.length; i++) {
        totalLength += this.cart.items[i].quantity
      }

      return totalLength
    }
  }
}
</script>

<style lang="scss">
// Custom color palette
$primary-dark: #202022;
$secondary-gray: #878787;
$light-gray: #CACACA;
$accent-cyan: #00BBC9;
$accent-dark-cyan: #00747C;

// Override Bulma variables
$primary: $accent-cyan;
$link: $accent-dark-cyan;
$info: $accent-cyan;
$dark: $primary-dark;

@import 'bulma/bulma.sass';

// Custom styles with new color palette
.wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f5f5f5;
}

.navbar {
  background-color: $primary-dark !important;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  
  .navbar-item {
    color: $light-gray !important;
    
    &:hover {
      background-color: rgba(255,255,255,0.1) !important;
      color: white !important;
    }
  }
  
  .logo-text {
    font-size: 1.5rem;
    font-weight: bold;
    color: $accent-cyan;
    margin-left: 10px;
  }
  
  .navbar-burger span {
    background-color: $light-gray;
  }
  
  .button {
    &.is-primary {
      background-color: $accent-cyan;
      border-color: $accent-cyan;
      
      &:hover {
        background-color: $accent-dark-cyan;
        border-color: $accent-dark-cyan;
      }
    }
    
    &.is-info {
      background-color: $accent-dark-cyan;
      border-color: $accent-dark-cyan;
      
      &:hover {
        background-color: darken($accent-dark-cyan, 10%);
      }
    }
    
    &.is-success {
      background-color: $accent-cyan;
      border-color: $accent-cyan;
      
      &:hover {
        background-color: $accent-dark-cyan;
      }
    }
  }
}

.section {
  flex: 1;
}

.footer {
  background-color: $primary-dark;
  color: $light-gray;
  padding: 2rem 1.5rem;
  margin-top: auto;
}

.lds-dual-ring {
  display: inline-block;
  width:80px;
  height:80px;
}
.lds-dual-ring::after {
  content:"";
  display: block;
  width:64px;
  height: 64px;
  margin:8px;
  border-radius: 50%;
  border: 6px solid $accent-cyan;
  border-color: $accent-cyan transparent $accent-cyan transparent;
  animation: lds-dual-ring 1.2s linear infinite;
}
@keyframes lds-dual-ring {
  0% {
    transform: rotate(0deg)
  }
  100% {
    transform: rotate(360deg);
  }
}
.is-loading-bar {
  height:0;
  overflow: hidden;
  -webkit-transition: all 0.3s;
  transition: all 0.3s;
  &.is-loading {
    height:80px;
  }
}
</style>

