# Use specific version (avoid :latest for production)
FROM nginx:1.26-alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static website files
COPY index.html /usr/share/nginx/html/

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

# Switch to non-root user (security best practice)
USER nginx

# Expose HTTP port
EXPOSE 80

# Healthcheck for container monitoring
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q -O - http://localhost || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
