# Guía de Instalación y Ejecución

## Opción 1: Usando Docker (Recomendado)

### Requisitos Previos
- Docker instalado
- Docker Compose instalado

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd tpFinal
```

2. **Configurar claves de Stripe**
   
   Antes de ejecutar el script, necesitas obtener tus claves de test de Stripe:
   - Crear cuenta en: https://dashboard.stripe.com/register
   - Obtener claves en: https://dashboard.stripe.com/test/apikeys
   - El script te pedirá estas claves durante la instalación

3. **Ejecutar el script de inicio automático**
```bash
chmod +x start.sh
./start.sh
```

El script automáticamente:
- Crea los archivos .env con tus claves de Stripe
- Levanta los contenedores de Docker
- Ejecuta las migraciones
- Crea datos de ejemplo

4. **Acceder a la aplicación**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- Admin Panel: http://localhost:8000/admin

### Usuarios de Prueba
- **Admin**: username=`admin`, password=`admin123`
- **Cliente**: username=`customer`, password=`customer123`

### Tarjeta de Prueba de Stripe
- **Número**: 4242 4242 4242 4242
- **Fecha**: Cualquier fecha futura
- **CVC**: Cualquier 3 dígitos

---

## Opción 2: Instalación Manual

### Requisitos Previos
- Python 3.8+
- Node.js 14+
- PostgreSQL 13+

### Backend (Django)

1. **Crear y activar entorno virtual**
```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

2. **Instalar dependencias**
```bash
pip install -r requirements.txt
```

3. **Configurar la base de datos**
Crear una base de datos PostgreSQL:
```sql
CREATE DATABASE ecommerce_db;
CREATE USER ecommerce_user WITH PASSWORD 'ecommerce_password';
GRANT ALL PRIVILEGES ON DATABASE ecommerce_db TO ecommerce_user;
```

4. **Configurar variables de entorno**
Crear archivo `.env`:
```env
SECRET_KEY=tu-clave-secreta-aqui
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

DB_NAME=ecommerce_db
DB_USER=ecommerce_user
DB_PASSWORD=ecommerce_password
DB_HOST=localhost
DB_PORT=5432

# Get your test keys from: https://dashboard.stripe.com/test/apikeys
STRIPE_PUBLISHABLE_KEY=pk_test_your_actual_key_here
STRIPE_SECRET_KEY=sk_test_your_actual_key_here
```

Crear archivo `ecommerce_vue/.env`:
```env
VUE_APP_API_URL=http://localhost:8000
VUE_APP_STRIPE_PUBLISHABLE_KEY=pk_test_your_actual_key_here
```

5. **Ejecutar migraciones**
```bash
python manage.py migrate
```

6. **Crear datos de ejemplo**
```bash
python manage.py create_sample_data
```

7. **Ejecutar el servidor**
```bash
python manage.py runserver
```

### Frontend (Vue.js)

1. **Configurar variables de entorno**
```bash
cd ecommerce_vue
cp .env.example .env
# Edit .env and add your Stripe publishable key
```

2. **Instalar dependencias**
```bash
cd ecommerce_vue
npm install
```

2. **Ejecutar servidor de desarrollo**
```bash
npm run serve
```

3. **Acceder a la aplicación**
- Frontend: http://localhost:8080
- Backend API: http://localhost:8000

---

## Comandos Útiles

### Docker

**Ver logs**
```bash
docker-compose logs -f backend
docker-compose logs -f frontend
```

**Reiniciar servicios**
```bash
docker-compose restart
```

**Detener servicios**
```bash
docker-compose down
```

**Recrear contenedores**
```bash
docker-compose down
docker-compose up -d --build
```

**Ejecutar comandos en el contenedor**
```bash
# Crear superusuario
docker-compose exec backend python manage.py createsuperuser

# Crear migraciones
docker-compose exec backend python manage.py makemigrations

# Aplicar migraciones
docker-compose exec backend python manage.py migrate

# Acceder a la shell de Django
docker-compose exec backend python manage.py shell
```

### Sin Docker

**Crear superusuario**
```bash
python manage.py createsuperuser
```

**Crear migraciones**
```bash
python manage.py makemigrations
```

**Aplicar migraciones**
```bash
python manage.py migrate
```

**Recolectar archivos estáticos**
```bash
python manage.py collectstatic
```

---

## Estructura de la Aplicación

### Backend (Django)
- **products/**: Gestión de categorías y productos/servicios
- **orders/**: Gestión de órdenes y suscripciones
- **users/**: Gestión de usuarios y perfiles
- **ecommerce_project/**: Configuración principal

### Frontend (Vue.js)
- **src/views/**: Páginas principales
  - `Home.vue`: Página de inicio
  - `Services.vue`: Catálogo completo de servicios
  - `MyServices.vue`: Servicios comprados del usuario
  - `Product.vue`: Detalle de un servicio
  - `Cart.vue`: Carrito de compras
  - `Checkout.vue`: Proceso de pago
  - `MyAccount.vue`: Cuenta del usuario
  - `Login.vue` y `SignUp.vue`: Autenticación

- **src/components/**: Componentes reutilizables
  - `ProductBox.vue`: Tarjeta de producto
  - `OrderSummery.vue`: Resumen de orden

---

## Solución de Problemas

### El frontend no se conecta al backend
- Verificar que el backend esté corriendo en el puerto 8000
- Verificar configuración de CORS en `settings.py`

### Error de base de datos
- Verificar que PostgreSQL esté corriendo
- Verificar credenciales en `.env`
- Ejecutar migraciones: `python manage.py migrate`

### Error de Stripe
- Verificar claves de API en archivos `.env` (backend y frontend)
- Asegurarse de usar claves de test (comienzan con `pk_test_` y `sk_test_`)
- Obtener claves reales de: https://dashboard.stripe.com/test/apikeys
- Las claves placeholder deben ser reemplazadas antes de usar la aplicación

### Puerto ya en uso
```bash
# Cambiar puerto del backend
python manage.py runserver 8001

# Cambiar puerto del frontend
npm run serve -- --port 8081
```

---

## Próximos Pasos

1. Personalizar los servicios en el admin panel
2. Agregar imágenes a los productos
3. Configurar claves de Stripe reales para producción
4. Ajustar estilos y colores del frontend
5. Configurar dominio personalizado

---

## Soporte

Para más información, consultar el archivo `HOSTING_SERVICES_README.md`
