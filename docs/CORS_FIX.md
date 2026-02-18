# CORS Configuration Fix

## Issue Description

When attempting to log in to the system from the frontend (running on `localhost:3000` or `localhost:8080`), users encountered the following error:

```
Cross-Origin Request Blocked: The Same Origin Policy disallows reading the remote resource at http://127.0.0.1:8000/api/v1/token/login/. (Reason: CORS request did not succeed)
```

This error occurred because the Django backend was not properly configured to handle Cross-Origin Resource Sharing (CORS) requests from the Vue.js frontend.

## Root Cause

While the `django-cors-headers` package was installed and the middleware was correctly positioned, the CORS configuration was incomplete. Specifically:

1. **Missing `CORS_ALLOW_CREDENTIALS`**: Without this setting, the browser would not include authentication credentials (like tokens) in cross-origin requests.
2. **Implicit header/method configuration**: While django-cors-headers has defaults, explicitly defining allowed headers and methods improves security and maintainability.
3. **Missing REST Framework authentication configuration**: Token authentication wasn't explicitly configured.

## Solution

Added comprehensive CORS configuration to `ecommerce_project/settings.py`:

```python
# CORS settings for proper authentication
CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_HEADERS = [
    'accept',
    'accept-encoding',
    'authorization',
    'content-type',
    'dnt',
    'origin',
    'user-agent',
    'x-csrftoken',
    'x-requested-with',
]
CORS_ALLOW_METHODS = [
    'DELETE',
    'GET',
    'OPTIONS',
    'PATCH',
    'POST',
    'PUT',
]

# REST Framework settings
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework.authentication.TokenAuthentication',
    ],
}
```

## Configuration Details

### CORS_ALLOW_CREDENTIALS = True
This setting allows cookies and authorization headers to be included in cross-origin requests. This is essential for token-based authentication where the frontend needs to send the auth token in the Authorization header.

### CORS_ALLOW_HEADERS
Explicitly defines which HTTP headers can be used in cross-origin requests:
- `authorization`: Required for sending authentication tokens
- `content-type`: Required for JSON payloads
- `x-csrftoken`: Required for CSRF protection in POST/PUT/DELETE requests
- Other standard headers for proper request handling

### CORS_ALLOW_METHODS
Explicitly defines which HTTP methods are allowed:
- `GET`: Reading resources
- `POST`: Creating resources
- `PUT`: Updating resources (full replacement)
- `PATCH`: Updating resources (partial update)
- `DELETE`: Deleting resources
- `OPTIONS`: CORS preflight requests

### REST_FRAMEWORK Configuration
Ensures Django REST Framework uses token authentication by default, which integrates with Djoser's token authentication system.

## Testing the Fix

### Prerequisites
1. Backend server running on `http://127.0.0.1:8000`
2. Sample data created (includes admin user)

### Manual Testing

#### 1. Test CORS Preflight Request
```bash
curl -X OPTIONS http://127.0.0.1:8000/api/v1/token/login/ \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: content-type,authorization" \
  -I
```

Expected response headers:
```
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Headers: accept, accept-encoding, authorization, content-type, dnt, origin, user-agent, x-csrftoken, x-requested-with
Access-Control-Allow-Methods: DELETE, GET, OPTIONS, PATCH, POST, PUT
```

#### 2. Test Actual Login
```bash
curl -X POST http://127.0.0.1:8000/api/v1/token/login/ \
  -H "Origin: http://localhost:3000" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

Expected response:
```json
{
  "auth_token": "bea4f881df6552749867453d23afdfd69b060e7f"
}
```

### Frontend Testing
1. Start the backend server: `python manage.py runserver 0.0.0.0:8000`
2. Start the frontend: `cd ecommerce_vue && npm run dev`
3. Navigate to the login page
4. Try logging in with:
   - Username: `admin`
   - Password: `admin123`
5. Login should now succeed without CORS errors

## Security Considerations

### Allowed Origins
CORS is configured to only allow requests from specific origins:
```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8000",
    "http://127.0.0.1:8000",
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:8080",
    "http://127.0.0.1:8080",
    "http://192.168.0.107:8080"
]
```

**Important**: For production deployments:
1. Update `CORS_ALLOWED_ORIGINS` to include only your production domain
2. Remove development origins (localhost, 127.0.0.1)
3. Use HTTPS instead of HTTP
4. Consider using environment variables for origin configuration

### Best Practices
1. **Never use `CORS_ALLOW_ALL_ORIGINS = True` in production** - This would allow any website to make requests to your API
2. **Keep credentials enabled only when necessary** - `CORS_ALLOW_CREDENTIALS` should only be enabled if you need to send cookies or auth headers
3. **Be specific with allowed headers and methods** - Only allow what your application actually needs
4. **Use HTTPS in production** - Always use secure connections for production deployments

## Troubleshooting

### CORS errors still occurring
1. Verify the frontend origin matches one in `CORS_ALLOWED_ORIGINS`
2. Check browser console for the exact error message
3. Verify the backend server is running
4. Clear browser cache and try again

### Authentication not working
1. Verify user exists in database
2. Check that `REST_FRAMEWORK` authentication is configured
3. Verify token is being sent in Authorization header
4. Check Django logs for authentication errors

### Preflight requests failing
1. Verify `CorsMiddleware` is positioned correctly (before CommonMiddleware)
2. Check that OPTIONS method is allowed
3. Verify all required headers are in `CORS_ALLOW_HEADERS`

## Related Files
- `ecommerce_project/settings.py`: Main configuration file
- `ecommerce_vue/src/main.js`: Frontend API configuration
- `requirements.txt`: Python dependencies including django-cors-headers

## References
- [django-cors-headers Documentation](https://github.com/adamchainz/django-cors-headers)
- [MDN CORS Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [Django REST Framework Authentication](https://www.django-rest-framework.org/api-guide/authentication/)
