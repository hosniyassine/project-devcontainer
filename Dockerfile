# ============================================
# Stage 1 : Build de l'application Angular
# ============================================
FROM node:20-alpine AS build

WORKDIR /app

# Copie des fichiers de dépendances
COPY package.json package-lock.json* ./

# Installation des dépendances
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

# Copie du code source
COPY . .

# Build Angular en mode production
RUN npx ng build --configuration production

# ============================================
# Stage 2 : Serveur Nginx pour servir l'app
# ============================================
FROM nginx:alpine

# Copie des fichiers buildés vers le répertoire par défaut de Nginx
COPY --from=build /app/dist/ecommerce-vetements/browser /usr/share/nginx/html

# Configuration Nginx pour le routage Angular (SPA)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposition du port 80
EXPOSE 80

# Démarrage de Nginx
CMD ["nginx", "-g", "daemon off;"]
