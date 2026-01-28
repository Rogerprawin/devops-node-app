# Use official Node.js image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package files first (layer caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source code
COPY . .

# App listens on this port
EXPOSE 3000

# Start the application
CMD ["node", "index.js"]
