# Stage 1: Build Stage
FROM node:14-alpine AS builder

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# Copy the rest of the application source code
COPY . .

# Build the application (e.g., assuming a React app or similar)
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Remove default static files from Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copy only the build output (static files) from the builder stage
COPY --from=builder /usr/src/app/build /usr/share/nginx/html/

# Expose port 80 to serve the application
EXPOSE 80

# Run Nginx in the foreground (to keep the container running)
CMD ["nginx", "-g", "daemon off;"]
