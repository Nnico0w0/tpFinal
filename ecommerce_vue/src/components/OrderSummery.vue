<template>
    <div class="box mb-4">
        <div class="level">
            <div class="level-left">
                <div class="level-item">
                    <h3 class="is-size-4">Order #{{ order.id }}</h3>
                </div>
            </div>
            <div class="level-right">
                <div class="level-item">
                    <span class="tag" :class="{
                        'is-warning': order.status === 'PENDING',
                        'is-success': order.status === 'COMPLETED',
                        'is-danger': order.status === 'CANCELLED'
                    }">
                        {{ order.status }}
                    </span>
                </div>
            </div>
        </div>

        <p class="has-text-grey mb-4">{{ formatDate(order.created_at) }}</p>

        <h4 class="is-size-5">Products</h4>

        <table class="table is-fullwidth">
            <thead>
                <tr>
                    <td>Product</td>
                    <td>Price</td>
                    <td>Quantity</td>
                    <td>Billing Cycle</td>
                    <td>Total</td>
                    <td>Status</td>
                </tr>
            </thead>

            <tbody>
                <tr v-for="item in order.items" v-bind:key="item.product.id">
                    <td>{{ item.product.name }}</td>
                    <td>${{ item.product.price }}/month</td>
                    <td>{{ item.quantity }}</td>
                    <td>{{ item.billing_cycle_months }} month(s)</td>
                    <td>${{ getItemTotal(item).toFixed(2) }}</td>
                    <td>
                        <span v-if="item.subscription" class="tag" :class="{
                            'is-success': item.subscription.status === 'ACTIVE',
                            'is-warning': item.subscription.status === 'SUSPENDED',
                            'is-danger': item.subscription.status === 'EXPIRED'
                        }">
                            {{ item.subscription.status }}
                        </span>
                        <span v-else class="tag is-light">No subscription</span>
                    </td>
                </tr>
            </tbody>

            <tfoot>
                <tr>
                    <th colspan="4">Total Paid:</th>
                    <th>${{ order.paid_amount }}</th>
                    <th></th>
                </tr>
            </tfoot>
        </table>
    </div>
</template>

<script>
export default {
    name: 'OrderSummery',
    props: {
        order: Object
    },
    methods: {
        getItemTotal(item) {
            return item.quantity * item.product.price * item.billing_cycle_months
        },
        orderTotalLength(order) {
            return order.items.reduce( (acc, currentVal) => {
                return acc += currentVal.quantity
            }, 0)
        },
        formatDate(dateString) {
            const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' }
            return new Date(dateString).toLocaleDateString('es-ES', options)
        }
    }
}
</script>