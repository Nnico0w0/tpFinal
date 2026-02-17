<template>
    <div class="page-services">
        <div class="columns is-multiline">
            <div class="column is-12">
                <h1 class="title">All Hosting Services</h1>
            </div>

            <div class="column is-12">
                <div class="tabs is-centered">
                    <ul>
                        <li :class="{'is-active': selectedCategory === null}">
                            <a @click="filterByCategory(null)">Todos</a>
                        </li>
                        <li v-for="category in categories" :key="category.id" 
                            :class="{'is-active': selectedCategory === category.id}">
                            <a @click="filterByCategory(category.id)">{{ category.name }}</a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="column is-12" v-if="filteredProducts.length === 0">
                <div class="notification is-info">
                    <p>No hay servicios disponibles en esta categoría.</p>
                </div>
            </div>

            <ProductBox 
                v-for="product in filteredProducts"
                v-bind:key="product.id"
                v-bind:product="product"/>
        </div>
    </div>
</template>

<script>
import axios from 'axios'
import ProductBox from '@/components/ProductBox'

export default {
    name: 'Services',
    components: {
        ProductBox
    },
    data() {
        return {
            products: [],
            categories: [],
            selectedCategory: null
        }
    },
    mounted() {
        document.title = 'Servicios | Hosting Services Store'
        this.getCategories()
        this.getAllProducts()
    },
    computed: {
        filteredProducts() {
            if (this.selectedCategory === null) {
                return this.products
            }
            return this.products.filter(product => product.category === this.selectedCategory)
        }
    },
    methods: {
        async getCategories() {
            await axios
                .get('/api/v1/products/categories/')
                .then(response => {
                    this.categories = response.data
                })
                .catch(error => {
                    console.log(error)
                })
        },
        async getAllProducts() {
            this.$store.commit('setIsLoading', true)
            
            await axios
                .get('/api/v1/products/all/')
                .then(response => {
                    this.products = response.data
                })
                .catch(error => {
                    console.log(error)
                })

            this.$store.commit('setIsLoading', false)
        },
        filterByCategory(categoryId) {
            this.selectedCategory = categoryId
        }
    }
}
</script>
