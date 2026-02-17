# 🚀 Guía de Uso Rápido - Hosting Services Store

## Inicio Rápido (5 minutos)

### 1. Levantar la Aplicación
```bash
chmod +x start.sh
./start.sh
```

Espera a que termine el proceso. Verás este mensaje:
```
✅ Setup complete!
================================================
🌐 Access the application:
   Frontend: http://localhost:3000
   Backend API: http://localhost:8000
   Admin Panel: http://localhost:8000/admin
```

### 2. Acceder a la Aplicación
Abre tu navegador en: **http://localhost:3000**

---

## 👤 Como Usuario (Cliente)

### Registrarse
1. Click en **"Registrarse"** en la navegación
2. Completa el formulario
3. Click en **"Sign Up"**
4. Serás redirigido al login

### Login
1. Click en **"Iniciar Sesión"**
2. Ingresa username y password
3. Click en **"Log In"**

### Ver Servicios Disponibles
1. Click en **"Todos los Servicios"** en la navegación
2. Navega por las categorías:
   - Shared Hosting
   - VPS Hosting
   - Dedicated Servers
   - Cloud Hosting
3. Click en un servicio para ver detalles

### Comprar un Servicio

#### Paso 1: Agregar al Carrito
1. En la página de un servicio, ingresa la cantidad
2. Click en **"Add to cart"**
3. Verás una notificación verde de confirmación

#### Paso 2: Ir al Checkout
1. Click en el ícono del carrito 🛒
2. Revisa tu carrito
3. Click en **"Proceed to checkout"**
4. Serás redirigido al login si no estás logueado

#### Paso 3: Completar Información
Completa el formulario con:
- Nombre y Apellido
- Email
- Teléfono
- Dirección
- Código Postal
- Ciudad
- **Ciclo de Facturación**: Selecciona 1, 3, 6 o 12 meses

#### Paso 4: Pagar con Stripe (Modo Test)
1. Ingresa los datos de la tarjeta de prueba:
   - **Número**: `4242 4242 4242 4242`
   - **Fecha**: Cualquier fecha futura (ej: 12/25)
   - **CVC**: Cualquier 3 dígitos (ej: 123)

2. Click en **"Pay with Stripe"**

3. Espera la confirmación

4. Serás redirigido a la página de éxito ✅

### Ver Mis Servicios
1. Click en **"Mis Servicios"** en la navegación
2. Verás todos tus servicios activos con:
   - Nombre del servicio
   - Estado (ACTIVE/SUSPENDED/EXPIRED)
   - Fecha de inicio
   - Fecha de vencimiento
   - Dominio (si fue configurado)

### Ver Mis Órdenes
1. Click en **"Mi Cuenta"** en la navegación
2. Verás todas tus órdenes con:
   - Número de orden
   - Productos comprados
   - Ciclo de facturación
   - Estado de la suscripción
   - Total pagado
3. Click en **"Log out"** para cerrar sesión

---

## 🔧 Como Administrador

### Login como Admin
Usa las credenciales por defecto:
- **Username**: `admin`
- **Password**: `admin123`

### Acceder al Panel de Admin
1. Después de login, verás un botón **"Admin Panel"** amarillo
2. Click en ese botón
3. Serás redirigido a: http://localhost:8000/admin

### Gestionar Categorías
1. En el admin, click en **"Categories"**
2. Para agregar una nueva:
   - Click en **"Add Category"**
   - Ingresa nombre (el slug se genera automático)
   - Click en **"Save"**

### Gestionar Productos/Servicios
1. Click en **"Products"**
2. Para agregar un nuevo servicio:
   - Click en **"Add Product"**
   - Completa:
     - Nombre y slug
     - Categoría
     - Descripción
     - Precio mensual
     - **Storage (GB)**
     - **RAM (GB)**
     - **CPU Cores**
   - Opcionalmente agrega imágenes
   - Click en **"Save"**

### Gestionar Órdenes
1. Click en **"Orders"**
2. Verás todas las órdenes con:
   - Usuario
   - Estado (PENDING/COMPLETED/CANCELLED)
   - Monto pagado
   - Fecha
3. Click en una orden para ver detalles
4. Puedes cambiar el estado si es necesario

### Gestionar Suscripciones
1. Click en **"Subscriptions"**
2. Verás todas las suscripciones
3. Puedes:
   - Ver detalles
   - Cambiar estado (ACTIVE/SUSPENDED/EXPIRED)
   - Agregar nombre de dominio
   - Modificar fechas

### Gestionar Usuarios
1. Click en **"User profiles"**
2. Verás todos los perfiles de usuario
3. Puedes cambiar roles (ADMIN/CUSTOMER)
4. Activar/desactivar usuarios

---

## 💡 Tips y Trucos

### Para Clientes

**Ahorra dinero con ciclos largos:**
- 3 meses: 5% descuento
- 6 meses: 10% descuento
- 12 meses: 15% descuento

**Ver especificaciones rápidamente:**
En el catálogo, cada servicio muestra iconos con:
- 💾 Storage
- 🧠 RAM
- ⚙️ CPU

**Filtrar por categoría:**
En "Todos los Servicios", usa las tabs para filtrar:
- Todos
- Shared Hosting
- VPS Hosting
- Dedicated Servers
- Cloud Hosting

### Para Administradores

**Crear productos en lote:**
Usa el comando de Django:
```bash
docker-compose exec backend python manage.py shell
```
Luego crea productos programáticamente.

**Exportar datos:**
En el admin, selecciona múltiples elementos y usa las acciones del admin.

**Ver estadísticas:**
Desde el admin puedes ver:
- Total de órdenes por estado
- Suscripciones activas vs vencidas
- Productos más vendidos

---

## 🧪 Tarjetas de Prueba de Stripe

### Tarjetas Exitosas
- **Básica**: `4242 4242 4242 4242`
- **Visa**: `4012 8888 8888 1881`
- **Mastercard**: `5555 5555 5555 4444`

### Tarjetas que Requieren Autenticación
- `4000 0025 0000 3155` - Activará SCA (Strong Customer Authentication)

### Tarjetas Declinadas
- **Genérica**: `4000 0000 0000 0002`
- **Fondos insuficientes**: `4000 0000 0000 9995`
- **Tarjeta perdida**: `4000 0000 0000 9987`

### Otros Detalles
- **Fecha de Vencimiento**: Cualquier fecha futura
- **CVC**: Cualquier 3 dígitos
- **Código Postal**: Cualquier código

---

## 📱 Accesos Rápidos

### URLs Principales
- **Home**: http://localhost:3000/
- **Servicios**: http://localhost:3000/services
- **Mis Servicios**: http://localhost:3000/my-services
- **Carrito**: http://localhost:3000/cart
- **Login**: http://localhost:3000/log-in
- **Registro**: http://localhost:3000/sign-up
- **Admin**: http://localhost:8000/admin

### API Endpoints
- **Productos**: http://localhost:8000/api/v1/products/all/
- **Categorías**: http://localhost:8000/api/v1/products/categories/
- **Mis Órdenes**: http://localhost:8000/api/v1/orders/list/ (requiere auth)
- **Mis Suscripciones**: http://localhost:8000/api/v1/orders/subscriptions/ (requiere auth)

---

## 🛑 Solución Rápida de Problemas

### No puedo acceder a la aplicación
```bash
# Ver estado de los contenedores
docker-compose ps

# Ver logs
docker-compose logs -f
```

### Olvidé mi contraseña de admin
```bash
# Crear nuevo superusuario
docker-compose exec backend python manage.py createsuperuser
```

### La base de datos está vacía
```bash
# Crear datos de ejemplo
docker-compose exec backend python manage.py create_sample_data
```

### El carrito no funciona
1. Limpia el localStorage del navegador
2. Refresca la página
3. Login nuevamente

### Error de Stripe
1. Verifica que uses tarjetas de test
2. Verifica que las claves de API sean de test (pk_test_...)

---

## 📞 Siguiente Pasos

1. ✅ Familiarízate con la aplicación
2. ✅ Prueba el flujo completo de compra
3. ✅ Explora el panel de admin
4. ✅ Personaliza los productos
5. ✅ Agrega tus propios servicios
6. ✅ Configura imágenes para los productos
7. ✅ Ajusta los precios según tu negocio

---

## 🎓 Recursos Adicionales

- **Documentación Completa**: Ver `HOSTING_SERVICES_README.md`
- **Guía de Instalación**: Ver `INSTALLATION_GUIDE.md`
- **Resumen de Cambios**: Ver `CHANGES_SUMMARY.md`

---

¡Disfruta tu Hosting Services Store! 🎉
