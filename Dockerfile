# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Upgrade Alpine packages
RUN apk update && apk upgrade

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Upgrade Alpine packages in final image
RUN apk update && apk upgrade

COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
