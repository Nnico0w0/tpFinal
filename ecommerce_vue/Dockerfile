# Dockerfile multi-stage para Vue.js Frontend

# Stage 1: Build
FROM node:16-alpine as build-stage

WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar código fuente
COPY . .

# Construir aplicación para producción
RUN npm run build

# Stage 2: Production
FROM nginx:alpine as production-stage

# Copiar archivos construidos desde el stage anterior
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copiar configuración personalizada de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]