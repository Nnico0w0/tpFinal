#!/bin/bash

# ========================================
# Complete Project Startup Script
# ========================================
# This script starts the entire project with all services
# Backend API will be accessible at http://localhost:8000
# Frontend will be accessible at http://localhost:3000

set -e  # Exit on any error

echo "================================================"
echo "🚀 Starting E-commerce Project"
echo "================================================"
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✅ Docker is available and running"
echo ""

# Check for docker compose command (v2 vs v1)
if docker compose version > /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose version > /dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "❌ Docker Compose is not available."
    echo "   Please install Docker Compose."
    exit 1
fi

echo "✅ Docker Compose is available"
echo ""

# Stop any existing containers
echo "🛑 Stopping any existing containers..."
$DOCKER_COMPOSE down > /dev/null 2>&1 || true
echo ""

# Build and start containers
echo "🔨 Building and starting containers..."
echo "   This may take a few minutes on first run..."
$DOCKER_COMPOSE up -d --build

if [ $? -ne 0 ]; then
    echo "❌ Failed to start containers"
    exit 1
fi

echo ""
echo "✅ Containers started successfully"
echo ""

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if $DOCKER_COMPOSE exec -T db pg_isready -U ecommerce_user > /dev/null 2>&1; then
        echo "✅ Database is ready"
        break
    fi
    attempt=$((attempt + 1))
    echo "   Attempt $attempt/$max_attempts..."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "❌ Database failed to start after $max_attempts attempts"
    echo "   Check logs with: $DOCKER_COMPOSE logs db"
    exit 1
fi

echo ""

# Wait a bit for backend to finish migrations
echo "⏳ Waiting for backend to complete migrations..."
sleep 5

# Check if backend is running
echo "🔍 Checking backend status..."
max_attempts=15
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:8000/admin/ > /dev/null 2>&1; then
        echo "✅ Backend is running and responding"
        break
    fi
    attempt=$((attempt + 1))
    echo "   Attempt $attempt/$max_attempts..."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "⚠️  Backend may not be ready yet, but continuing..."
    echo "   Check logs with: $DOCKER_COMPOSE logs backend"
fi

echo ""
echo "================================================"
echo "✅ Project started successfully!"
echo "================================================"
echo ""
echo "📍 Access points:"
echo "   🌐 Frontend:    http://localhost:3000"
echo "   🔧 Backend API: http://localhost:8000"
echo "   👤 Admin Panel: http://localhost:8000/admin"
echo ""
echo "📋 Available API endpoints:"
echo "   • http://localhost:8000/api/v1/public/users/"
echo "   • http://localhost:8000/api/v1/products/all/"
echo "   • http://localhost:8000/api/v1/orders/all/"
echo ""
echo "🔧 Useful commands:"
echo "   View logs:        $DOCKER_COMPOSE logs -f"
echo "   Stop project:     $DOCKER_COMPOSE down"
echo "   Restart project:  $DOCKER_COMPOSE restart"
echo "   View containers:  docker ps"
echo ""
echo "📝 Notes:"
echo "   • First run may take longer to download images and build"
echo "   • Database data persists between restarts"
echo "   • Use Ctrl+C to stop following logs if running with -f"
echo ""
echo "================================================"
