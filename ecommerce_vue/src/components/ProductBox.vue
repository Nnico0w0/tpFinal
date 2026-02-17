<template>
    <div class="column is-3">
        <div class="box">
            <figure class="image mb-4" v-if="product.get_thumbnail">
                <img :src=" 'http://127.0.0.1:8000' + product.get_thumbnail" alt="">
            </figure>

            <h3 class="is-size-4">{{ product.name }}</h3>
            <p class="is-size-6 has-text-weight-bold">${{ product.price }}/mes</p>
            
            <div class="content mt-3" v-if="product.storage_gb || product.ram_gb || product.cpu_cores">
                <p class="is-size-7 mb-1" v-if="product.storage_gb">
                    <span class="icon is-small"><i class="fas fa-hdd"></i></span>
                    {{ product.storage_gb }} GB Storage
                </p>
                <p class="is-size-7 mb-1" v-if="product.ram_gb">
                    <span class="icon is-small"><i class="fas fa-memory"></i></span>
                    {{ product.ram_gb }} GB RAM
                </p>
                <p class="is-size-7 mb-1" v-if="product.cpu_cores">
                    <span class="icon is-small"><i class="fas fa-microchip"></i></span>
                    {{ product.cpu_cores }}
                </p>
            </div>

            <router-link v-bind:to="product.get_absolute_url" class="button is-dark mt-4">Ver Detalles</router-link>

        </div>
    </div>
</template>

<script>
export default {
    name: 'ProductBox',
    props: { // receive product
        product: Object
    }
}
</script>

<style scoped>
  .image {
    margin-top: -1.25rem;
    margin-left: -1.25rem;
    margin-right: -1.25rem;
  }
</style>

