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

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✓ .env file created"
else
    echo "✓ .env file already exists"
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
