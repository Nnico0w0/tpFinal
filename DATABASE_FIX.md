# Database and Registration Configuration Fix

## Changes Made

### 1. Docker Compose Configuration
- Updated `docker-compose.yml` to use `.env` file for environment variables
- Added `env_file` directive to all services
- Added fallback default values using `${VARIABLE:-default}` syntax
- Improved database healthcheck with shorter intervals and start_period

### 2. Docker Entrypoint Script
- Created `docker-entrypoint.sh` to properly wait for database before starting backend
- Script handles:
  - Database connection verification
  - Running migrations automatically
  - Collecting static files
  - Starting Django server

### 3. Environment Configuration
- Created `.env` file from `.env.example`
- Set `DEBUG=True` for development mode
- Configured database connection parameters
- Updated `start-project.sh` to auto-create `.env` if missing

### 4. Dockerfile Updates
- Added ENTRYPOINT to use `docker-entrypoint.sh`
- Ensured script is executable in container

### 5. Documentation Updates
- Updated README with .env configuration details
- Documented the automatic .env creation process
- Listed important environment variables

## Registration Endpoint

The registration endpoint is provided by Djoser and is available at:
- **URL**: `POST /api/v1/users/`
- **Required fields**:
  - `username`: String (unique)
  - `email`: String (valid email)
  - `password`: String (min 8 characters)

### Example Registration Request:
```bash
curl -X POST http://localhost:8000/api/v1/users/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "testpass123"
  }'
```

### Expected Response (Success):
```json
{
  "email": "test@example.com",
  "username": "testuser",
  "id": 1
}
```

## Database Configuration

The database is now properly configured with:
1. PostgreSQL 13 running in Docker container
2. Healthcheck to ensure database is ready before backend starts
3. Automatic migrations on backend startup
4. Persistent data storage using Docker volumes

### Database Connection Flow:
1. Docker Compose starts PostgreSQL container
2. Healthcheck verifies database is accepting connections
3. Backend container starts (only after database is healthy)
4. `docker-entrypoint.sh` waits for database connection
5. Migrations run automatically
6. Django server starts

## Testing the Setup

1. **Start the project:**
```bash
./start-project.sh
```

2. **Verify database is running:**
```bash
docker compose logs db
```

3. **Verify backend is running:**
```bash
curl http://localhost:8000/admin/
```

4. **Test registration:**
```bash
curl -X POST http://localhost:8000/api/v1/users/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "testpass123"
  }'
```

5. **Test login:**
```bash
curl -X POST http://localhost:8000/api/v1/token/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "testpass123"
  }'
```

## Troubleshooting

### Database Connection Issues
- Check if database is healthy: `docker compose ps`
- View database logs: `docker compose logs db`
- Restart database: `docker compose restart db`

### Migration Issues
- View backend logs: `docker compose logs backend`
- Run migrations manually: `docker compose exec backend python manage.py migrate`

### Registration Not Working
- Check backend logs for errors: `docker compose logs backend`
- Verify endpoint: `curl http://localhost:8000/api/v1/users/` (should return 405 Method Not Allowed for GET, 201 for valid POST)
- Ensure CORS is configured (already done in settings.py)
