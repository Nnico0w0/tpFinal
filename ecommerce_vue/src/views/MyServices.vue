<template>
    <div class="page-my-services">
        <div class="columns is-multiline">

            <div class="column is-12">
                <h1 class="title">Mis Servicios</h1>
            </div>

            <div class="column is-12" v-if="subscriptions.length === 0">
                <div class="notification is-info">
                    <p>No tienes servicios activos aún.</p>
                    <router-link to="/services" class="button is-primary mt-4">Ver Servicios Disponibles</router-link>
                </div>
            </div>

            <div class="column is-12" v-else>
                <div class="box" v-for="subscription in subscriptions" :key="subscription.id">
                    <div class="columns">
                        <div class="column is-8">
                            <h3 class="is-size-4">{{ subscription.product_name }}</h3>
                            <p class="has-text-grey">
                                <strong>Estado:</strong> 
                                <span class="tag" :class="{
                                    'is-success': subscription.status === 'ACTIVE',
                                    'is-warning': subscription.status === 'SUSPENDED',
                                    'is-danger': subscription.status === 'EXPIRED'
                                }">
                                    {{ subscription.status }}
                                </span>
                            </p>
                            <p class="has-text-grey" v-if="subscription.domain_name">
                                <strong>Dominio:</strong> {{ subscription.domain_name }}
                            </p>
                            <p class="has-text-grey">
                                <strong>Fecha de inicio:</strong> {{ formatDate(subscription.start_date) }}
                            </p>
                            <p class="has-text-grey">
                                <strong>Fecha de vencimiento:</strong> {{ formatDate(subscription.end_date) }}
                            </p>
                        </div>
                        <div class="column is-4 has-text-right">
                            <button class="button is-info" v-if="subscription.status === 'ACTIVE'">
                                Gestionar Servicio
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios'

export default {
    name: 'MyServices',
    data() {
        return {
            subscriptions: []
        }
    },
    mounted() {
        document.title = 'Mis Servicios | Hosting Services Store'
        this.getMyServices()
    },
    methods: {
        async getMyServices() {
            this.$store.commit('setIsLoading', true)
            
            await axios
                .get('/api/v1/orders/subscriptions/')
                .then(response => {
                    this.subscriptions = response.data
                })
                .catch(error => {
                    console.log(error)
                })

            this.$store.commit('setIsLoading', false)
        },
        formatDate(dateString) {
            const options = { year: 'numeric', month: 'long', day: 'numeric' }
            return new Date(dateString).toLocaleDateString('es-ES', options)
        }
    }
}
</script>
