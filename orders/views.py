import stripe

from django.conf import settings
from django.contrib.auth.models import User
from django.http import Http404
from django.utils import timezone
from datetime import timedelta

from rest_framework import status, authentication, permissions
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import OrderItem, Order, Subscription
from .serializers import (
    OrderItemSerializer, OrderSerializer, 
    MyOrderSerializer, MyOrderItemSerializer, SubscriptionSerializer)


@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def checkout(request):
    serializer = OrderSerializer(data=request.data)

    if serializer.is_valid():
        print('serialize validated -------------')
        
        # Use test mode stripe key
        stripe.api_key = settings.STRIPE_SECRET_KEY
        paid_amount = sum(
            item.get('quantity') * item.get('product').price 
            for item in serializer.validated_data['items']
        )
        
        try:
            # Stripe charge - in test mode if STRIPE_TEST_MODE is True
            # For test mode, you can use test card: 4242 4242 4242 4242
            charge = stripe.Charge.create(
                amount=int(paid_amount * 100),
                currency='USD',
                description='Charge from Hosting Services Store',
                source=serializer.validated_data.get('stripe_token', 'tok_visa')  # Default to test token if not provided
            )

            # Save order with COMPLETED status
            order = serializer.save(user=request.user, paid_amount=paid_amount, status='COMPLETED')
            
            # Create subscriptions for each order item
            for item in order.items.all():
                # Calculate end date based on billing cycle
                end_date = timezone.now() + timedelta(days=30 * item.billing_cycle_months)
                Subscription.objects.create(
                    order_item=item,
                    end_date=end_date,
                    status='ACTIVE'
                )
            
            print('try success --------------------')
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except Exception as e:
            print(f'try fail ----------------- {str(e)}')
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class OrderListApi(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        orders = Order.objects.filter(user=request.user)
        serializer = MyOrderSerializer(orders, many=True)
        return Response(serializer.data)


class SubscriptionListApi(APIView):
    """API to list all active subscriptions for the authenticated user"""
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        # Get all subscriptions for the user's orders
        subscriptions = Subscription.objects.filter(
            order_item__order__user=request.user
        ).select_related('order_item__product')
        serializer = SubscriptionSerializer(subscriptions, many=True)
        return Response(serializer.data)