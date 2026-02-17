# buildServe - E-commerce Hosting Services Store

Sistema de e-commerce completo desarrollado con Django REST Framework (backend) y Vue.js 3 (frontend) para la venta de servicios de hosting.

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

- **Usuarios**: `GET /api/v1/public/users/list/` - Lista todos los usuarios registrados
- **Productos**: `GET /api/v1/products/all/` - Lista todos los productos disponibles
- **Órdenes**: `GET /api/v1/orders/all/` - Lista todas las órdenes realizadas

## Requisitos del Sistema

### Backend (Django)
- Python 3.8+
- pip (gestor de paquetes de Python)
- SQLite (incluido) o PostgreSQL (producción)

### Frontend (Vue.js)
- Node.js 16+
- npm 7+

## Instalación y Configuración

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd tpFinal
```

### 2. Configurar el Backend (Django)

#### Instalar dependencias de Python

```bash
# Instalar dependencias del sistema (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y libjpeg-dev zlib1g-dev

# Instalar dependencias de Python
pip install -r requirements.txt

# Si tienes problemas con versiones, actualiza psycopg2 y stripe:
pip install --upgrade psycopg2-binary stripe
```

#### Configurar la base de datos

```bash
# Ejecutar migraciones
python manage.py migrate

# Crear un superusuario
python manage.py createsuperuser
```

#### Iniciar el servidor Django

```bash
# Desarrollo (SQLite)
python manage.py runserver 0.0.0.0:8000

# El backend estará disponible en http://localhost:8000
# Panel de administración: http://localhost:8000/admin
```

### 3. Configurar el Frontend (Vue.js)

```bash
# Navegar al directorio del frontend
cd ecommerce_vue

# Instalar dependencias de npm
npm install

# Iniciar el servidor de desarrollo
npm run dev

# El frontend estará disponible en http://localhost:8080
```

### 4. Configurar Variables de Entorno (Opcional)

Para producción o uso con Docker, crear archivos `.env`:

#### Backend `.env`:
```env
SECRET_KEY=tu-clave-secreta-aqui
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,tu-dominio.com

# PostgreSQL (opcional)
DB_NAME=ecommerce_db
DB_USER=ecommerce_user
DB_PASSWORD=tu-password
DB_HOST=localhost
DB_PORT=5432

# Stripe
STRIPE_PUBLISHABLE_KEY=pk_test_tu_clave
STRIPE_SECRET_KEY=sk_test_tu_clave
```

#### Frontend `ecommerce_vue/.env`:
```env
VUE_APP_API_URL=http://localhost:8000
VUE_APP_STRIPE_PUBLISHABLE_KEY=pk_test_tu_clave
```

## Uso del Sistema

### Acceder a la aplicación

1. **Frontend**: http://localhost:8080
2. **Backend API**: http://localhost:8000/api/v1/
3. **Admin Panel**: http://localhost:8000/admin

### APIs Públicas

```bash
# Listar usuarios
curl http://localhost:8000/api/v1/public/users/list/

# Listar productos
curl http://localhost:8000/api/v1/products/all/

# Listar órdenes
curl http://localhost:8000/api/v1/orders/all/
```

### Navegación del Frontend

- **Inicio**: Página principal con productos destacados
- **Todos los Servicios**: Catálogo completo de servicios de hosting
- **Usuarios**: Lista pública de todos los usuarios
- **Productos**: Lista pública de todos los productos
- **Compras**: Lista pública de todas las órdenes
- **Carrito**: Gestión del carrito de compras
- **Mi Cuenta**: Panel del usuario (requiere autenticación)
- **Mis Servicios**: Suscripciones activas (requiere autenticación)

## Compilar para Producción

### Backend
```bash
# Recolectar archivos estáticos
python manage.py collectstatic --noinput

# Usar servidor WSGI como Gunicorn
pip install gunicorn
gunicorn ecommerce_project.wsgi:application --bind 0.0.0.0:8000
```

### Frontend
```bash
cd ecommerce_vue
npm run build

# Los archivos compilados estarán en ecommerce_vue/dist/
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
├── manage.py
└── requirements.txt
```

## Comandos Útiles

### Backend
```bash
# Crear migraciones
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate

# Crear superusuario
python manage.py createsuperuser

# Shell de Django
python manage.py shell

# Verificar proyecto
python manage.py check
```

### Frontend
```bash
# Instalar dependencias
npm install

# Desarrollo
npm run dev

# Compilar para producción
npm run build

# Vista previa de build
npm run preview
```

## Solución de Problemas

### Error: "No module named 'django'"
```bash
pip install -r requirements.txt
```

### Error con Pillow (imágenes)
```bash
sudo apt-get install -y libjpeg-dev zlib1g-dev
pip install --upgrade Pillow
```

### Error con psycopg2 en Python 3.12+
```bash
pip install --upgrade psycopg2-binary
```

### Puerto ya en uso
```bash
# Cambiar el puerto del servidor
python manage.py runserver 0.0.0.0:8001
npm run dev -- --port 8081
```

## Tecnologías Utilizadas

### Backend
- Django 3.2
- Django REST Framework 3.12
- Djoser (autenticación)
- Stripe (pagos)
- Pillow (imágenes)
- SQLite/PostgreSQL

### Frontend
- Vue.js 3
- Vue Router 4
- Vuex 4
- Axios
- Bulma CSS
- Vite

## Licencia

Copyright (c) 2026 buildServe - Todos los derechos reservados

## Soporte

Para problemas o preguntas, por favor crea un issue en el repositorio.
