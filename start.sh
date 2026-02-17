#!/bin/bash

echo "🚀 Hosting Services Store - Quick Start Script"
echo "=============================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✓ Docker is running"
echo ""

# Function to get Stripe keys
get_stripe_keys() {
    echo "📝 Stripe Configuration"
    echo "   You need test API keys from Stripe."
    echo "   Get them from: https://dashboard.stripe.com/test/apikeys"
    echo ""
    
    read -p "   Enter your Stripe PUBLISHABLE key (pk_test_...): " stripe_pub_key
    read -p "   Enter your Stripe SECRET key (sk_test_...): " stripe_secret_key
    
    if [[ ! $stripe_pub_key =~ ^pk_test_ ]] || [[ ! $stripe_secret_key =~ ^sk_test_ ]]; then
        echo "⚠️  Warning: Keys should start with pk_test_ and sk_test_ for test mode"
        read -p "   Continue anyway? (y/n): " continue_choice
        if [[ $continue_choice != "y" ]]; then
            echo "❌ Setup cancelled"
            exit 1
        fi
    fi
}

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating backend .env file..."
    
    get_stripe_keys
    
    cat > .env << EOF
# Django Backend
SECRET_KEY=django-insecure-dev-key-$(openssl rand -hex 32)
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1,backend

# Database
DB_NAME=ecommerce_db
DB_USER=ecommerce_user
DB_PASSWORD=ecommerce_password
DB_HOST=db
DB_PORT=5432

# Stripe Test Keys
STRIPE_PUBLISHABLE_KEY=$stripe_pub_key
STRIPE_SECRET_KEY=$stripe_secret_key

# Frontend
VUE_APP_API_URL=http://localhost:8000
EOF
    echo "✓ Backend .env file created"
else
    echo "✓ Backend .env file already exists"
    # Read existing stripe key
    stripe_pub_key=$(grep STRIPE_PUBLISHABLE_KEY .env | cut -d '=' -f2)
fi

# Create frontend .env file
if [ ! -f ecommerce_vue/.env ]; then
    echo "📝 Creating frontend .env file..."
    cat > ecommerce_vue/.env << EOF
VUE_APP_API_URL=http://localhost:8000
VUE_APP_STRIPE_PUBLISHABLE_KEY=$stripe_pub_key
EOF
    echo "✓ Frontend .env file created"
else
    echo "✓ Frontend .env file already exists"
fi

echo ""
echo "🐳 Starting Docker containers..."
docker-compose up -d

echo ""
echo "⏳ Waiting for database to be ready..."
echo "   This may take 30-60 seconds..."

# Wait for database to be ready with retry logic
max_attempts=30
attempt=0
until docker-compose exec -T db pg_isready -U ecommerce_user > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ $attempt -eq $max_attempts ]; then
        echo "❌ Database failed to start after $max_attempts attempts"
        exit 1
    fi
    echo "   Waiting for database... attempt $attempt/$max_attempts"
    sleep 2
done

echo "✓ Database is ready"

echo ""
echo "🔄 Running migrations..."
docker-compose exec -T backend python manage.py migrate

echo ""
echo "📦 Creating sample data..."
docker-compose exec -T backend python manage.py create_sample_data

echo ""
echo "✅ Setup complete!"
echo ""
echo "================================================"
echo "🌐 Access the application:"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:8000"
echo "   Admin Panel: http://localhost:8000/admin"
echo ""
echo "👤 Test Users:"
echo "   Admin: username=admin, password=admin123"
echo "   Customer: username=customer, password=customer123"
echo ""
echo "💳 Test Stripe Card:"
echo "   Card: 4242 4242 4242 4242"
echo "   Expiry: Any future date"
echo "   CVC: Any 3 digits"
echo "================================================"
