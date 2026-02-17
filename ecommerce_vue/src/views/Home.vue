<template>
  <div class="home">
    <section class="hero is-medium hero-custom mb-6">
      <div class="hero-body has-text-centered">
        <p class="title mb-6 hero-title">Bienvenido a buildServe</p>
        <p class="subtitle hero-subtitle">Las mejores soluciones de hosting para tus proyectos</p>
      </div>
    </section>

    <!-- Top 3 Best Sellers Section -->
    <div v-if="topSellingProducts.length > 0" class="top-sellers-section mb-6">
      <div class="container">
        <h2 class="is-size-2 has-text-centered mb-5 section-title">
          <span class="icon-trophy">🏆</span> Top 3 Más Vendidos
        </h2>
        <div class="columns is-multiline">
          <ProductBox 
            v-for="(product, index) in topSellingProducts"
            v-bind:key="product.id"
            v-bind:product="product"
            :class="'top-seller-badge-' + (index + 1)"/>
        </div>
      </div>
    </div>

    <!-- Latest Products Section -->
    <div class="container">
      <div class="columns is-multiline">
        <div class="column is-12">
          <h2 class="is-size-2 has-text-centered mb-5 section-title">Últimos Planes de Hosting</h2>
        </div>
        
        <ProductBox 
          v-for="product in lastestProducts"
          v-bind:key="product.id"
          v-bind:product="product"/>
      </div>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import axios from 'axios'
import ProductBox from '@/components/ProductBox.vue'

export default {
  name: 'Home',
  data() {
    return {
      lastestProducts: [],
      topSellingProducts: []
    }
  },
  components: {
    ProductBox,
  },
  mounted() {
    this.getTopSellingProducts()
    this.getLastestProducts()
    document.title = 'Inicio | buildServe - Hosting Services Store'
  },
  methods: {
    async getTopSellingProducts() {
      this.$store.commit('setIsLoading', true)

      await axios.get('/api/v1/products/top-selling')
      .then(response => {
        this.topSellingProducts = response.data
      })
      .catch(error => {
        console.log(error)
      })
      
      this.$store.commit('setIsLoading', false)
    },
    async getLastestProducts() {
      this.$store.commit('setIsLoading', true)

      await  axios.get('/api/v1/products/latest')
      .then(response => {
        this.lastestProducts = response.data
      })
      .catch( error => {
        console.log(error)
      })
      
      this.$store.commit('setIsLoading', false)
    }
  }
}
</script>

<style scoped>
.hero-custom {
  background: linear-gradient(135deg, #202022 0%, #00747C 100%);
}

.hero-title {
  color: #00BBC9;
  font-weight: bold;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.hero-subtitle {
  color: #CACACA;
}

.section-title {
  color: #202022;
  font-weight: bold;
  margin-bottom: 2rem;
}

.icon-trophy {
  font-size: 2rem;
  margin-right: 10px;
}

.top-sellers-section {
  background-color: #f8f9fa;
  padding: 3rem 0;
  border-radius: 8px;
}

.top-seller-badge-1 {
  position: relative;
}

.top-seller-badge-1::before {
  content: '🥇';
  position: absolute;
  top: 10px;
  right: 10px;
  font-size: 2rem;
  z-index: 10;
}

.top-seller-badge-2::before {
  content: '🥈';
  position: absolute;
  top: 10px;
  right: 10px;
  font-size: 2rem;
  z-index: 10;
}

.top-seller-badge-3::before {
  content: '🥉';
  position: absolute;
  top: 10px;
  right: 10px;
  font-size: 2rem;
  z-index: 10;
}
</style>
