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
sleep 10

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
