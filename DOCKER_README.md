# Docker Setup - Instrucciones de Uso

## 📦 Proyecto E-commerce Dockerizado

Este proyecto ha sido configurado para ejecutarse con **Docker** y **Docker Compose**, organizando la aplicación en tres contenedores separados:

- **Frontend**: Vue.js servido por Nginx (Puerto 3000)
- **Backend**: Django API (Puerto 8000)
- **Base de datos**: PostgreSQL (Puerto 5432)

## 🚀 Inicio Rápido

### 1. Prerrequisitos
- Docker y Docker Compose instalados
- Puertos 3000, 8000, y 5432 disponibles

### 2. Construir y ejecutar
```bash
# Construir e iniciar todos los servicios
docker-compose up --build

# Para ejecutar en segundo plano
docker-compose up -d --build
```

### 3. Acceder a la aplicación
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Admin Django**: http://localhost:8000/admin
- **PostgreSQL**: localhost:5432

## 🔧 Comandos Útiles

### Gestión de contenedores
```bash
# Ver logs de todos los servicios
docker-compose logs

# Ver logs de un servicio específico
docker-compose logs backend
docker-compose logs frontend
docker-compose logs db

# Parar todos los servicios
docker-compose down

# Parar y eliminar volúmenes (¡CUIDADO! Borra la BD)
docker-compose down -v
```

### Comandos de Django
```bash
# Ejecutar comandos Django en el contenedor
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py createsuperuser
docker-compose exec backend python manage.py collectstatic

# Entrar al shell de Django
docker-compose exec backend python manage.py shell

# Acceder al contenedor backend
docker-compose exec backend bash
```

### Comandos de Base de Datos
```bash
# Acceder a PostgreSQL
docker-compose exec db psql -U ecommerce_user -d ecommerce_db

# Hacer backup de la BD
docker-compose exec db pg_dump -U ecommerce_user ecommerce_db > backup.sql

# Restaurar backup
docker-compose exec -T db psql -U ecommerce_user -d ecommerce_db < backup.sql
```

## ⚙️ Configuración

### Variables de Entorno
El archivo [.env.example](.env.example) contiene todas las variables de entorno necesarias. Para usarlas:

```bash
cp .env.example .env
# Editar .env con tus valores específicos
```

### Configuración de Desarrollo vs Producción
- **Desarrollo**: DEBUG=True, usar docker-compose.yml
- **Producción**: DEBUG=False, cambiar SECRET_KEY, configurar ALLOWED_HOSTS

## 📁 Estructura de Archivos Docker

```
project/
├── Dockerfile                 # Backend Django
├── docker-compose.yml         # Orquestación de servicios
├── .dockerignore             # Archivos excluidos del backend
├── .env.example              # Variables de entorno de ejemplo
└── ecommerce_vue/
    ├── Dockerfile            # Frontend Vue.js
    ├── .dockerignore         # Archivos excluidos del frontend
    └── nginx.conf            # Configuración de Nginx
```

## 🔄 Flujo de Desarrollo

1. **Realizar cambios en el código**
2. **Reconstruir servicios afectados**:
   ```bash
   # Solo backend
   docker-compose up --build backend
   
   # Solo frontend
   docker-compose up --build frontend
   ```

3. **Para cambios en dependencias** (requirements.txt o package.json):
   ```bash
   docker-compose build --no-cache
   docker-compose up
   ```

## 🐛 Solución de Problemas

### Problemas Comunes

1. **Puerto ya en uso**:
   ```bash
   # Cambiar puertos en docker-compose.yml
   ports:
     - "3001:80"  # En lugar de 3000:80
   ```

2. **Problemas de permisos**:
   ```bash
   sudo chown -R $USER:$USER media/
   ```

3. **Base de datos no inicializada**:
   ```bash
   docker-compose down -v
   docker-compose up --build
   ```

4. **Limpiar todo y empezar de nuevo**:
   ```bash
   docker-compose down -v
   docker system prune -a
   docker-compose up --build
   ```

## 📝 Notas Importantes

- Los datos de PostgreSQL se persisten en un volumen Docker
- Los archivos media se montan como volumen para persistir uploads
- El frontend se construye para producción y se sirve con Nginx
- El backend incluye healthcheck para PostgreSQL antes de iniciar

## 🔐 Seguridad

Para producción, asegúrate de:
- Cambiar SECRET_KEY por uno único y seguro
- Establecer DEBUG=False
- Configurar ALLOWED_HOSTS correctamente
- Usar HTTPS (configurar proxy reverso)
- Actualizar credenciales de base de datos
- Configurar firewall apropiadamente