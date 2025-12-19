# ---------------------------
# Stage 1: Build Stage
# ---------------------------
FROM node:22-alpine AS builder

WORKDIR /app

# Copy only required files
COPY index.html .

# Optional: validate HTML (can be extended to build React/Vue/Angular)
RUN echo "Build completed"

# ---------------------------
# Stage 2: Runtime Stage
# ---------------------------
FROM nginx:1.26-alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built artifacts from builder stage
COPY --from=builder /app/index.html /usr/share/nginx/html/

# Set correct permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

# Use non-root user
USER nginx

# Expose HTTP port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q -O - http://localhost || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
