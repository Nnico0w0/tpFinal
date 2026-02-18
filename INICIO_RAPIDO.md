# Guía de Inicio Rápido

Esta guía te ayudará a configurar y ejecutar el proyecto desde cero después de clonarlo.

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Docker Desktop** (versión 20.10 o superior)
  - Descarga: https://docs.docker.com/get-docker/
  - Verifica que Docker esté corriendo antes de ejecutar el script

- **Git** (opcional, pero recomendado)
  - Para clonar el repositorio

## 🚀 Configuración Inicial (Primera Vez)

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/Nnico0w0/tpFinal.git
cd tpFinal
```

### Paso 2: Ejecutar el Script de Setup

```bash
chmod +x setup.sh
./setup.sh
```

El script `setup.sh` automatizará todo el proceso:

1. ✅ Verificará que Docker y Docker Compose estén instalados
2. ✅ Creará el archivo `.env` con configuración automática
3. ✅ Generará una SECRET_KEY segura para Django
4. ✅ Configurará el frontend Vue.js
5. ✅ Construirá las imágenes de Docker
6. ✅ Iniciará todos los servicios (base de datos, backend, frontend)
7. ✅ Verificará que todo esté funcionando correctamente

**Tiempo estimado**: 5-10 minutos (la primera vez tarda más por la descarga de imágenes)

## 🌐 Acceso a la Aplicación

Una vez completado el setup, podrás acceder a:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Panel de Administración**: http://localhost:8000/admin

### APIs Públicas Disponibles

- Usuarios: http://localhost:8000/api/v1/public/users/
- Productos: http://localhost:8000/api/v1/products/all/
- Órdenes: http://localhost:8000/api/v1/orders/all/

## 🔧 Comandos Útiles

### Ver Logs de los Servicios

```bash
# Todos los servicios
docker compose logs -f

# Solo backend
docker compose logs -f backend

# Solo frontend
docker compose logs -f frontend

# Solo base de datos
docker compose logs -f db
```

### Gestionar el Proyecto

```bash
# Detener el proyecto
docker compose down

# Reiniciar el proyecto
docker compose restart

# Reiniciar un servicio específico
docker compose restart backend

# Ver estado de los contenedores
docker ps

# Reset completo (borra datos)
docker compose down -v
./setup.sh
```

### Crear un Superusuario

```bash
docker compose exec backend python manage.py createsuperuser
```

### Cargar Datos de Ejemplo (si está disponible)

```bash
docker compose exec backend python manage.py create_sample_data
```

### Ejecutar Migraciones Manualmente

```bash
docker compose exec backend python manage.py migrate
```

## 🔄 Ejecuciones Posteriores

Si ya completaste el setup inicial, puedes usar el script más rápido:

```bash
./start-project.sh
```

Este script solo inicia los servicios sin reconstruir todo desde cero.

## ⚠️ Solución de Problemas Comunes

### "Docker is not running"

Asegúrate de que Docker Desktop esté abierto y en ejecución.

### "Port already in use" (Puerto en uso)

Algunos servicios ya están usando los puertos necesarios:

```bash
# Linux/macOS - Ver qué está usando el puerto
sudo lsof -i :8000  # Backend
sudo lsof -i :3000  # Frontend
sudo lsof -i :5432  # PostgreSQL

# Windows - Ver qué está usando el puerto
netstat -ano | findstr :8000  # Backend
netstat -ano | findstr :3000  # Frontend
netstat -ano | findstr :5432  # PostgreSQL

# Detener todos los contenedores Docker
docker compose down
```

### Error con la Base de Datos

```bash
# Reiniciar solo la base de datos
docker compose restart db

# Reset completo
docker compose down -v
./setup.sh
```

### Ver Logs de Errores

```bash
# Ver todos los logs
docker compose logs

# Ver logs recientes
docker compose logs --tail=100

# Seguir logs en tiempo real
docker compose logs -f
```

## 📚 Estructura del Proyecto

```
tpFinal/
├── setup.sh                 # Script de configuración inicial (usar primera vez)
├── start-project.sh         # Script de inicio rápido (ejecuciones posteriores)
├── docker-compose.yml       # Configuración de servicios Docker
├── .env                     # Variables de entorno (generado por setup.sh)
├── .env.example            # Plantilla de variables de entorno
├── ecommerce_project/      # Configuración Django
├── ecommerce_vue/          # Frontend Vue.js
├── products/               # App de productos
├── orders/                 # App de órdenes
├── users/                  # App de usuarios
└── README.md              # Documentación completa
```

## 🆘 ¿Necesitas Ayuda?

1. Revisa la documentación completa en `README.md`
2. Consulta los logs de errores con `docker compose logs`
3. Crea un issue en el repositorio de GitHub

## 🎯 Próximos Pasos

1. Explora el frontend en http://localhost:3000
2. Crea un superusuario para acceder al panel admin
3. Revisa las APIs públicas disponibles
4. Lee la documentación completa en `README.md`

---

**¡Listo!** Tu proyecto está configurado y corriendo. 🚀
