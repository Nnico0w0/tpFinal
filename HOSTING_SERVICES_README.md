# Hosting Services Store - E-commerce para Servicios de Hosting

Una aplicación web completa para la venta de servicios de hosting, construida con Django REST Framework y Vue.js.

## Características

- 🏪 Catálogo de servicios de hosting con especificaciones detalladas (Storage, RAM, CPU)
- 🔐 Sistema de autenticación de usuarios (registro, login)
- 🛒 Carrito de compras
- 💳 Integración con Stripe en modo de prueba para pagos
- 📦 Gestión de suscripciones automática
- 👤 Panel de usuario para ver servicios comprados
- 🔧 Panel de administración completo (solo para administradores)

## Tecnologías Utilizadas

### Backend
- Django 3.2
- Django REST Framework
- PostgreSQL
- Stripe API (modo test)
- Djoser (autenticación)

### Frontend
- Vue.js 3
- Vuex (gestión de estado)
- Vue Router
- Bulma CSS
- Axios

## Modelo de Datos

El sistema implementa el siguiente modelo relacional:

- **Person**: Información personal de usuarios
- **UserProfile**: Perfil extendido con roles (ADMIN/CUSTOMER)
- **Category**: Categorías de servicios (Shared, VPS, Dedicated, etc.)
- **Product**: Servicios de hosting con especificaciones
- **Order**: Órdenes de compra con estados (PENDING/COMPLETED/CANCELLED)
- **OrderItem**: Ítems de orden con ciclos de facturación
- **Subscription**: Suscripciones activas generadas después de la compra

## Instalación y Configuración

### Prerequisitos
- Docker y Docker Compose
- Python 3.8+
- Node.js 14+

### Con Docker (Recomendado)

1. Clonar el repositorio:
```bash
git clone <repository-url>
cd tpFinal
```

2. Crear archivo `.env` basado en `.env.example`:
```bash
cp .env.example .env
```

3. **IMPORTANTE**: Editar `.env` y reemplazar las claves de Stripe con tus propias claves de test:
```env
# Get your test keys from: https://dashboard.stripe.com/test/apikeys
STRIPE_PUBLISHABLE_KEY=pk_test_your_actual_test_key_here
STRIPE_SECRET_KEY=sk_test_your_actual_test_key_here
```

4. Crear archivo `.env` para Vue:
```bash
cp ecommerce_vue/.env.example ecommerce_vue/.env
```

5. **IMPORTANTE**: Editar `ecommerce_vue/.env` y reemplazar la clave de Stripe:
```env
VUE_APP_STRIPE_PUBLISHABLE_KEY=pk_test_your_actual_test_key_here
```

6. Levantar los servicios:
```bash
docker-compose up -d
```

5. Crear superusuario para el admin:
```bash
docker-compose exec backend python manage.py createsuperuser
```

6. Acceder a la aplicación:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- Admin Panel: http://localhost:8000/admin

## Uso de la Aplicación

### Para Usuarios (Clientes)

1. **Registro**: Crear una cuenta desde el botón "Registrarse"
2. **Ver Servicios**: Navegar por todos los servicios disponibles
3. **Agregar al Carrito**: Seleccionar servicios y agregarlos al carrito
4. **Checkout**: Completar la compra con datos de envío y pago
5. **Mis Servicios**: Ver todas las suscripciones activas

### Para Administradores

1. **Login**: Iniciar sesión con credenciales de administrador
2. **Admin Panel**: Acceder al panel de administración desde el botón "Admin Panel"
3. **Gestión**: CRUD completo de:
   - Personas y Perfiles de Usuario
   - Categorías
   - Productos/Servicios
   - Órdenes
   - Suscripciones

## Stripe en Modo Test

La aplicación está configurada para usar Stripe en modo de prueba.

### Configuración Requerida

1. Crear cuenta gratuita en Stripe: https://dashboard.stripe.com/register
2. Obtener tus claves de test en: https://dashboard.stripe.com/test/apikeys
3. Configurar las claves en los archivos `.env`:
   - Backend: `STRIPE_PUBLISHABLE_KEY` y `STRIPE_SECRET_KEY`
   - Frontend: `VUE_APP_STRIPE_PUBLISHABLE_KEY`

### Tarjetas de Prueba

Para realizar compras de prueba, usa estas tarjetas de test:

- **Visa exitosa**: 4242 4242 4242 4242
- **Requiere autenticación**: 4000 0025 0000 3155
- **Declinada**: 4000 0000 0000 0002

Usa cualquier fecha futura como vencimiento, cualquier CVC de 3 dígitos, y cualquier código postal.

## API Endpoints

### Productos
- `GET /api/v1/products/latest` - Últimos productos
- `GET /api/v1/products/all/` - Todos los productos
- `GET /api/v1/products/categories/` - Todas las categorías
- `GET /api/v1/products/<category>/<product>/` - Detalle de producto

### Órdenes
- `POST /api/v1/orders/checkout/` - Crear orden (requiere autenticación)
- `GET /api/v1/orders/list/` - Listar órdenes del usuario (requiere autenticación)
- `GET /api/v1/orders/subscriptions/` - Listar suscripciones del usuario (requiere autenticación)

### Autenticación
- `POST /api/v1/users/` - Registro de usuario
- `POST /api/v1/token/login/` - Login
- `POST /api/v1/token/logout/` - Logout

## Desarrollo

### Backend
```bash
# Instalar dependencias
pip install -r requirements.txt

# Aplicar migraciones
python manage.py migrate

# Crear superusuario
python manage.py createsuperuser

# Ejecutar servidor de desarrollo
python manage.py runserver
```

### Frontend
```bash
cd ecommerce_vue

# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run serve

# Build para producción
npm run build
```

## Estructura del Proyecto

```
tpFinal/
├── ecommerce_project/     # Configuración principal de Django
├── products/              # App de productos/servicios
├── orders/                # App de órdenes y suscripciones
├── users/                 # App de usuarios y perfiles
├── ecommerce_vue/         # Frontend Vue.js
│   ├── src/
│   │   ├── components/    # Componentes Vue
│   │   ├── views/         # Vistas/Páginas
│   │   ├── router/        # Configuración de rutas
│   │   └── store/         # Vuex store
│   └── public/
├── docker-compose.yml     # Configuración Docker
└── requirements.txt       # Dependencias Python
```

## Licencia

Este proyecto es parte de un trabajo final y está disponible para uso educativo.

## Contacto

Para más información, contactar al desarrollador.
