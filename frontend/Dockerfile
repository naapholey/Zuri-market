# --- Stage 1: Build the Vite application ---
FROM --platform=$BUILDPLATFORM node:20-alpine AS builder
WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package*.json ./
RUN npm ci

# Copy the rest of your application code
COPY . .

# Build the production assets (generates the 'dist' folder)
RUN npm run build

# --- Stage 2: Serve assets with Nginx ---
FROM nginx:alpine
# Copy the compiled static assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy your native Nginx configuration if you have one
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
