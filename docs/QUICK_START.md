# Guía Rápida - Acceso a la API

## ✨ Inicio Rápido

### Opción 1: Con Docker (Recomendado)

```bash
# En el directorio raíz del proyecto
./start-project.sh
```

Eso es todo! El script se encarga de todo automáticamente.

### Opción 2: Manual con Docker Compose

```bash
docker compose up -d --build
```

## 🌐 Acceder a los Servicios

Una vez iniciado el proyecto, los servicios estarán disponibles en:

| Servicio | URL | Descripción |
|----------|-----|-------------|
| Frontend | http://localhost:3000 | Interfaz de usuario Vue.js |
| Backend API | http://localhost:8000 | API REST de Django |
| Admin Panel | http://localhost:8000/admin | Panel de administración |
| Base de Datos | localhost:5432 | PostgreSQL (acceso directo) |

## 📋 Endpoints de la API

### APIs Públicas (sin autenticación)

```bash
# Listar todos los usuarios
GET http://localhost:8000/api/v1/public/users/

# Listar todos los productos
GET http://localhost:8000/api/v1/products/all/

# Listar todas las órdenes
GET http://localhost:8000/api/v1/orders/all/
```

### Ejemplos con curl

```bash
# Obtener lista de usuarios
curl http://localhost:8000/api/v1/public/users/

# Obtener lista de productos
curl http://localhost:8000/api/v1/products/all/

# Obtener lista de órdenes
curl http://localhost:8000/api/v1/orders/all/
```

### Ejemplos con navegador

Simplemente abre estas URLs en tu navegador:
- http://localhost:8000/api/v1/public/users/
- http://localhost:8000/api/v1/products/all/
- http://localhost:8000/api/v1/orders/all/

## 🔧 Comandos Útiles

### Ver logs en tiempo real
```bash
docker compose logs -f
```

### Ver logs de un servicio específico
```bash
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db
```

### Detener el proyecto
```bash
docker compose down
```

### Reiniciar el proyecto
```bash
docker compose restart
```

### Reset completo (elimina datos)
```bash
docker compose down -v
./start-project.sh
```

### Ver estado de contenedores
```bash
docker compose ps
```

### Ejecutar comandos en el backend
```bash
# Crear superusuario
docker compose exec backend python manage.py createsuperuser

# Acceder a la shell de Django
docker compose exec backend python manage.py shell

# Aplicar migraciones
docker compose exec backend python manage.py migrate

# Crear datos de prueba
docker compose exec backend python manage.py create_sample_data
```

### Acceder a la base de datos
```bash
# Conectarse a PostgreSQL
docker compose exec db psql -U ecommerce_user -d ecommerce_db
```

## 🐛 Solución de Problemas

### El backend no responde

```bash
# Ver logs del backend
docker compose logs backend

# Reiniciar el backend
docker compose restart backend
```

### Error de conexión a la base de datos

```bash
# Verificar que la base de datos esté corriendo
docker compose ps db

# Ver logs de la base de datos
docker compose logs db

# Reiniciar la base de datos
docker compose restart db
```

### Puerto ya en uso

Si el puerto 8000, 3000 o 5432 ya está en uso:

```bash
# Ver qué está usando el puerto (Linux/Mac)
sudo lsof -i :8000

# Windows
netstat -ano | findstr :8000

# Detener otros contenedores
docker compose down
```

### Rebuild completo

Si tienes problemas persistentes:

```bash
# Detener y limpiar todo
docker compose down -v
docker system prune -a

# Reconstruir desde cero
docker compose up -d --build
```

## 📝 Notas Importantes

1. **Primera ejecución**: La primera vez que ejecutes el proyecto, Docker descargará las imágenes base (Python, Node, Nginx, PostgreSQL) y construirá las imágenes personalizadas. Esto puede tardar varios minutos.

2. **Persistencia de datos**: Los datos de la base de datos se almacenan en un volumen de Docker, por lo que persisten entre reinicios. Para eliminarlos, usa `docker compose down -v`.

3. **Cambios en el código**: 
   - Backend: El código se sincroniza automáticamente gracias al volumen montado
   - Frontend: Puede requerir reconstruir la imagen con `docker compose up -d --build frontend`

4. **Variables de entorno**: El proyecto usa las variables de entorno configuradas en `docker-compose.yml`. Para cambiarlas, edita ese archivo.

5. **Acceso desde la red local**: Para acceder desde otros dispositivos en tu red, usa la IP de tu máquina en lugar de `localhost`.

## 🎯 Verificación Rápida

Para verificar que todo funciona correctamente:

```bash
# 1. Verificar contenedores
docker compose ps

# 2. Probar la API
curl http://localhost:8000/api/v1/public/users/

# 3. Abrir el frontend en el navegador
open http://localhost:3000  # Mac
xdg-open http://localhost:3000  # Linux
start http://localhost:3000  # Windows
```

Si todos estos comandos funcionan, ¡tu proyecto está correctamente configurado! 🎉
