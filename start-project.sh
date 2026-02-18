#!/bin/bash

# ========================================
# Complete Project Startup Script
# ========================================
# This script starts the entire project with all services
# Backend API will be accessible at http://localhost:8000
# Frontend will be accessible at http://localhost:3000
#
# Note: Make sure this script is executable
# Run: chmod +x start-project.sh

set -e  # Exit on any error

# Check if script is executable (for better user experience)
if [ ! -x "$0" ]; then
    echo "⚠️  This script is not executable. Attempting to fix..."
    chmod +x "$0"
    if [ $? -eq 0 ]; then
        echo "✅ Fixed! Re-running script..."
        exec "$0" "$@"
    else
        echo "❌ Could not make script executable. Please run: chmod +x $0"
        exit 1
    fi
fi

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

# Check if .env file exists, if not create it from .env.example
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        # Set DEBUG=True for development (cross-platform compatible)
        if [ "$(uname)" = "Darwin" ]; then
            # macOS (BSD sed)
            sed -i '' 's/DEBUG=False/DEBUG=True/g' .env
        else
            # Linux (GNU sed)
            sed -i 's/DEBUG=False/DEBUG=True/g' .env
        fi
        echo "✅ .env file created"
        echo "⚠️  Note: Using default configuration. For production, update .env with your own values."
    else
        echo "❌ .env.example not found. Please create .env file manually."
        exit 1
    fi
else
    echo "✅ .env file already exists"
fi
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
