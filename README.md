# buildServe - E-commerce Hosting Services Store

Sistema de e-commerce completo desarrollado con Django REST Framework (backend) y Vue.js 3 (frontend) para la venta de servicios de hosting.

> 📖 **¿Primera vez usando el proyecto?** Lee la [Guía de Inicio Rápido](INICIO_RAPIDO.md) para configurarlo en minutos.

## Características Principales

- 🔐 Autenticación de usuarios con Django + Djoser
- 🛍️ Carrito de compras completo
- 💳 Integración con Stripe para pagos
- 📦 Gestión de productos y categorías
- 🔄 Suscripciones de servicios de hosting
- 📊 APIs públicas para usuarios, productos y órdenes
- 💻 Interfaz moderna con Vue.js 3 y Bulma CSS

## APIs Públicas

El sistema incluye 3 APIs públicas accesibles sin autenticación:

- **Usuarios**: `GET /api/v1/public/users/` - Lista todos los usuarios registrados
- **Productos**: `GET /api/v1/products/all/` - Lista todos los productos disponibles
- **Órdenes**: `GET /api/v1/orders/all/` - Lista todas las órdenes realizadas

## 🚀 Inicio Rápido con Docker (Recomendado)

### Requisitos Previos
- Docker Desktop instalado y en ejecución
- Git (para clonar el repositorio)

### Pasos para Iniciar el Proyecto

1. **Clonar el repositorio**
```bash
git clone <url-del-repositorio>
cd tpFinal
```

2. **Ejecutar el script de setup (primera vez)**
```bash
chmod +x setup.sh
./setup.sh
```

Este script automatiza todo el proceso de configuración inicial:
- ✅ Verificar que Docker y Docker Compose estén disponibles
- ✅ Crear el archivo .env automáticamente desde .env.example
- ✅ Generar SECRET_KEY seguro para Django
- ✅ Configurar variables de entorno del frontend
- ✅ Construir las imágenes de los contenedores
- ✅ Iniciar la base de datos PostgreSQL
- ✅ Esperar a que la base de datos esté lista
- ✅ Iniciar el backend Django con migraciones automáticas
- ✅ Iniciar el frontend Vue.js
- ✅ Verificar que todos los servicios estén funcionando correctamente

**Alternativa**: Si ya has configurado el proyecto, puedes usar:
```bash
./start-project.sh
```

3. **Acceder a la aplicación**

Una vez que el script termine, podrás acceder a:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Panel de Administración**: http://localhost:8000/admin

### Configuración de Variables de Entorno

El proyecto utiliza un archivo `.env` para la configuración. Este archivo se crea automáticamente desde `.env.example` cuando ejecutas `start-project.sh`.

**Variables importantes:**
- `DEBUG`: Modo de depuración (True para desarrollo)
- `SECRET_KEY`: Clave secreta de Django (cambiar en producción)
- `DB_NAME`, `DB_USER`, `DB_PASSWORD`: Credenciales de PostgreSQL
- `DB_HOST`, `DB_PORT`: Host y puerto de la base de datos
- `STRIPE_PUBLISHABLE_KEY`, `STRIPE_SECRET_KEY`: Claves de Stripe para pagos (opcional)

Si necesitas personalizar la configuración, edita el archivo `.env` antes de iniciar el proyecto.

### Endpoints de API Disponibles

```bash
# Listar usuarios
curl http://localhost:8000/api/v1/public/users/

# Listar productos
curl http://localhost:8000/api/v1/products/all/

# Listar órdenes
curl http://localhost:8000/api/v1/orders/all/
```

### Comandos Útiles de Docker

```bash
# Ver los logs en tiempo real
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db

# Detener el proyecto
docker compose down

# Detener y eliminar los volúmenes (reset completo)
docker compose down -v

# Reiniciar un servicio
docker compose restart backend

# Ver el estado de los contenedores
docker compose ps

# Ejecutar comandos en el backend
docker compose exec backend python manage.py createsuperuser
docker compose exec backend python manage.py shell
```

## 📦 Instalación Manual (Sin Docker)

Si prefieres ejecutar el proyecto sin Docker:

### Requisitos del Sistema

#### Backend (Django)
- Python 3.8+
- pip (gestor de paquetes de Python)
- SQLite (incluido) o PostgreSQL (producción)

#### Frontend (Vue.js)
- Node.js 16+
- npm 7+

### 1. Configurar el Backend (Django)

```bash
# Instalar dependencias del sistema (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y libjpeg-dev zlib1g-dev

# Instalar dependencias de Python
pip install -r requirements.txt

# Ejecutar migraciones
python manage.py migrate

# Crear un superusuario
python manage.py createsuperuser

# Iniciar el servidor Django
python manage.py runserver 0.0.0.0:8000
```

### 2. Configurar el Frontend (Vue.js)

```bash
# Navegar al directorio del frontend
cd ecommerce_vue

# Instalar dependencias de npm
npm install

# Iniciar el servidor de desarrollo
npm run dev

# El frontend estará disponible en http://localhost:8080
```

## Estructura del Proyecto

```
tpFinal/
├── ecommerce_project/      # Configuración Django
├── ecommerce_vue/          # Frontend Vue.js
│   ├── src/
│   │   ├── views/         # Vistas/Páginas
│   │   ├── components/    # Componentes reutilizables
│   │   ├── router/        # Configuración de rutas
│   │   └── store/         # Estado global (Vuex)
│   └── package.json
├── users/                  # App de usuarios
├── products/               # App de productos
├── orders/                 # App de órdenes/compras
├── docker-compose.yml      # Configuración de Docker Compose
├── start-project.sh        # Script de inicio rápido
├── manage.py
└── requirements.txt
```

## Solución de Problemas

### Error: "Docker is not running"
Asegúrate de que Docker Desktop esté abierto y en ejecución.

### Error: "Port already in use"
Si los puertos 8000, 3000 o 5432 ya están en uso:
```bash
# Ver qué está usando el puerto
sudo lsof -i :8000
# O en Windows:
netstat -ano | findstr :8000

# Detener otros contenedores
docker compose down
```

### Error con la base de datos
```bash
# Reiniciar solo la base de datos
docker compose restart db

# O reset completo
docker compose down -v
./start-project.sh
```

### Ver logs de errores
```bash
# Ver todos los logs
docker compose logs

# Ver logs de un servicio específico
docker compose logs backend
docker compose logs frontend
docker compose logs db
```

### Error de CORS al intentar hacer login
Si ves errores como "Cross-Origin Request Blocked" al intentar hacer login:
1. Verifica que el backend esté corriendo en `http://127.0.0.1:8000`
2. Verifica que el frontend esté corriendo en uno de los puertos configurados (3000, 8080)
3. El proyecto ya incluye configuración CORS completa en `settings.py`
4. Para más detalles, consulta [`docs/CORS_FIX.md`](docs/CORS_FIX.md)

**Nota**: Si cambias el puerto del frontend, debes actualizar `CORS_ALLOWED_ORIGINS` en `ecommerce_project/settings.py`.

## Tecnologías Utilizadas

### Backend
- Django 3.2
- Django REST Framework 3.12
- Djoser (autenticación)
- Stripe (pagos)
- Pillow (imágenes)
- PostgreSQL (en Docker) / SQLite (local)

### Frontend
- Vue.js 3
- Vue Router 4
- Vuex 4
- Axios
- Bulma CSS
- Vite

### DevOps
- Docker & Docker Compose
- Nginx (para servir el frontend)
- PostgreSQL 13

## Licencia

Copyright (c) 2026 buildServe - Todos los derechos reservados

## Soporte

Para problemas o preguntas, por favor crea un issue en el repositorio.
