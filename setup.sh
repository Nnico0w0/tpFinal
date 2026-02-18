#!/bin/bash

# ========================================
# Setup Script - Configuración Inicial del Proyecto
# ========================================
# Este script configura el proyecto desde cero después de clonarlo
# Ejecuta todos los comandos importantes para levantar el proyecto
#
# Uso: chmod +x setup.sh && ./setup.sh

set -e  # Salir en caso de error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "================================================"
echo "🚀 Setup Script - E-commerce Project"
echo "================================================"
echo "Este script configurará todo lo necesario para"
echo "ejecutar el proyecto después de clonarlo."
echo "================================================"
echo ""

# ========================================
# 1. Verificar requisitos del sistema
# ========================================
echo "${BLUE}📋 Paso 1/7: Verificando requisitos del sistema...${NC}"
echo ""

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "${RED}❌ Docker no está instalado.${NC}"
    echo "   Por favor instala Docker Desktop desde:"
    echo "   https://docs.docker.com/get-docker/"
    exit 1
fi
echo "${GREEN}✅ Docker está instalado${NC}"

# Verificar si Docker está corriendo
if ! docker info > /dev/null 2>&1; then
    echo "${RED}❌ Docker no está corriendo.${NC}"
    echo "   Por favor inicia Docker Desktop primero."
    exit 1
fi
echo "${GREEN}✅ Docker está corriendo${NC}"

# Verificar Docker Compose
if docker compose version > /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose version > /dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "${RED}❌ Docker Compose no está disponible.${NC}"
    echo "   Por favor instala Docker Compose."
    exit 1
fi
echo "${GREEN}✅ Docker Compose está disponible${NC}"

# Verificar Git
if ! command -v git &> /dev/null; then
    echo "${YELLOW}⚠️  Git no está instalado (opcional)${NC}"
else
    echo "${GREEN}✅ Git está instalado${NC}"
fi

echo ""

# ========================================
# 2. Crear archivo .env para el backend
# ========================================
echo "${BLUE}📋 Paso 2/7: Configurando variables de entorno...${NC}"
echo ""

if [ -f .env ]; then
    echo "${YELLOW}⚠️  El archivo .env ya existe.${NC}"
    read -p "   ¿Deseas reemplazarlo? (s/N): " replace_env
    if [[ $replace_env =~ ^[Ss]$ ]]; then
        rm .env
        echo "${GREEN}✅ Archivo .env eliminado${NC}"
    else
        echo "${GREEN}✅ Usando archivo .env existente${NC}"
    fi
fi

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        
        # Generar SECRET_KEY aleatorio
        if command -v openssl &> /dev/null; then
            SECRET_KEY=$(openssl rand -hex 32)
            
            # Validar que SECRET_KEY se generó correctamente
            if [ -z "$SECRET_KEY" ]; then
                echo "${RED}❌ Error: No se pudo generar SECRET_KEY${NC}"
                exit 1
            fi
            
            if [ "$(uname)" = "Darwin" ]; then
                # macOS (BSD sed)
                sed -i '' "s/your-super-secret-key-change-this-in-production/django-insecure-$SECRET_KEY/g" .env
                sed -i '' 's/DEBUG=False/DEBUG=True/g' .env
            else
                # Linux (GNU sed)
                sed -i "s/your-super-secret-key-change-this-in-production/django-insecure-$SECRET_KEY/g" .env
                sed -i 's/DEBUG=False/DEBUG=True/g' .env
            fi
        else
            echo "${YELLOW}⚠️  openssl no disponible, usando SECRET_KEY por defecto${NC}"
            echo "   ADVERTENCIA: Cambia SECRET_KEY en .env para producción"
        fi
        
        echo "${GREEN}✅ Archivo .env creado desde .env.example${NC}"
        echo "${YELLOW}⚠️  Nota: Usando configuración por defecto.${NC}"
        echo "   Para producción, actualiza el archivo .env con tus propios valores."
    else
        echo "${RED}❌ .env.example no encontrado.${NC}"
        exit 1
    fi
fi

echo ""

# ========================================
# 3. Crear archivo .env para el frontend (opcional)
# ========================================
echo "${BLUE}📋 Paso 3/7: Configurando frontend...${NC}"
echo ""

if [ -d "ecommerce_vue" ]; then
    if [ ! -f ecommerce_vue/.env ]; then
        if [ -f ecommerce_vue/.env.example ]; then
            cp ecommerce_vue/.env.example ecommerce_vue/.env
            echo "${GREEN}✅ Archivo .env del frontend creado${NC}"
        else
            # Crear archivo .env básico para el frontend
            cat > ecommerce_vue/.env << EOF
VUE_APP_API_URL=http://localhost:8000
EOF
            echo "${GREEN}✅ Archivo .env del frontend creado${NC}"
        fi
    else
        echo "${GREEN}✅ Archivo .env del frontend ya existe${NC}"
    fi
fi

echo ""

# ========================================
# 4. Limpiar contenedores previos (si existen)
# ========================================
echo "${BLUE}📋 Paso 4/7: Limpiando contenedores previos...${NC}"
echo ""

$DOCKER_COMPOSE down > /dev/null 2>&1 || true
echo "${GREEN}✅ Contenedores previos detenidos${NC}"

echo ""

# ========================================
# 5. Construir e iniciar contenedores
# ========================================
echo "${BLUE}📋 Paso 5/7: Construyendo e iniciando contenedores...${NC}"
echo "   (Esto puede tomar varios minutos la primera vez)"
echo ""

$DOCKER_COMPOSE up -d --build

if [ $? -ne 0 ]; then
    echo "${RED}❌ Error al iniciar los contenedores${NC}"
    echo "   Ejecuta '$DOCKER_COMPOSE logs' para ver los errores"
    exit 1
fi

echo ""
echo "${GREEN}✅ Contenedores iniciados exitosamente${NC}"
echo ""

# ========================================
# 6. Esperar a que la base de datos esté lista
# ========================================
echo "${BLUE}📋 Paso 6/7: Esperando a que la base de datos esté lista...${NC}"
echo ""

# Obtener el nombre de usuario de la BD desde .env
DB_USER=$(grep "^DB_USER=" .env | cut -d '=' -f2)
if [ -z "$DB_USER" ]; then
    DB_USER="ecommerce_user"  # fallback al valor por defecto
fi

max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if $DOCKER_COMPOSE exec -T db pg_isready -U "$DB_USER" > /dev/null 2>&1; then
        echo "${GREEN}✅ Base de datos está lista${NC}"
        break
    fi
    attempt=$((attempt + 1))
    printf "   Intento %d/%d...\r" $attempt $max_attempts
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo ""
    echo "${RED}❌ La base de datos no se inició después de $max_attempts intentos${NC}"
    echo "   Ejecuta '$DOCKER_COMPOSE logs db' para ver los errores"
    exit 1
fi

echo ""

# Esperar a que el backend esté listo con retry logic
echo "⏳ Esperando a que el backend complete las migraciones..."
max_attempts=20
attempt=0

while [ $attempt -lt $max_attempts ]; do
    # Verificar si el backend responde correctamente
    if $DOCKER_COMPOSE exec -T backend python manage.py check > /dev/null 2>&1; then
        echo "${GREEN}✅ Backend completó inicialización${NC}"
        break
    fi
    attempt=$((attempt + 1))
    printf "   Intento %d/%d...\r" $attempt $max_attempts
    sleep 3
done

if [ $attempt -eq $max_attempts ]; then
    echo ""
    echo "${YELLOW}⚠️  El backend podría no estar completamente listo${NC}"
    echo "   Verificando accesibilidad web..."
fi

# ========================================
# 7. Verificar que el backend esté respondiendo
# ========================================
echo "${BLUE}📋 Paso 7/7: Verificando servicios...${NC}"
echo ""

max_attempts=15
attempt=0

while [ $attempt -lt $max_attempts ]; do
    # Usar una petición simple al endpoint raíz en lugar de /admin/
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/ | grep -q "200\|302\|301" > /dev/null 2>&1; then
        echo "${GREEN}✅ Backend está corriendo y respondiendo${NC}"
        break
    fi
    attempt=$((attempt + 1))
    printf "   Verificando backend... intento %d/%d\r" $attempt $max_attempts
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo ""
    echo "${YELLOW}⚠️  El backend podría no estar listo todavía${NC}"
    echo "   Puedes verificar con: $DOCKER_COMPOSE logs backend"
fi

echo ""

# ========================================
# Resumen Final
# ========================================
echo ""
echo "================================================"
echo "${GREEN}✅ ¡Setup completado exitosamente!${NC}"
echo "================================================"
echo ""
echo "${BLUE}📍 Puntos de acceso:${NC}"
echo "   🌐 Frontend:      http://localhost:3000"
echo "   🔧 Backend API:   http://localhost:8000"
echo "   👤 Panel Admin:   http://localhost:8000/admin"
echo ""
echo "${BLUE}📋 Endpoints de API públicos:${NC}"
echo "   • http://localhost:8000/api/v1/public/users/"
echo "   • http://localhost:8000/api/v1/products/all/"
echo "   • http://localhost:8000/api/v1/orders/all/"
echo ""
echo "${BLUE}🔧 Comandos útiles:${NC}"
echo "   Ver logs:              $DOCKER_COMPOSE logs -f"
echo "   Ver logs específicos:  $DOCKER_COMPOSE logs -f backend"
echo "   Detener proyecto:      $DOCKER_COMPOSE down"
echo "   Reiniciar proyecto:    $DOCKER_COMPOSE restart"
echo "   Estado contenedores:   docker ps"
echo "   Reiniciar desde cero:  $DOCKER_COMPOSE down -v && ./setup.sh"
echo ""
echo "${BLUE}📝 Notas importantes:${NC}"
echo "   • La primera ejecución tarda más (descarga de imágenes)"
echo "   • Los datos de la BD persisten entre reinicios"
echo "   • Para crear un superusuario:"
echo "     $DOCKER_COMPOSE exec backend python manage.py createsuperuser"
echo "   • Para cargar datos de ejemplo (si existe el comando):"
echo "     $DOCKER_COMPOSE exec backend python manage.py create_sample_data"
echo ""
echo "================================================"
echo "${GREEN}¡El proyecto está listo para usar!${NC}"
echo "================================================"
echo ""
