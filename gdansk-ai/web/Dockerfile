FROM node:18-alpine as installer

WORKDIR /app

COPY . ./
RUN npm ci -q
RUN npm run build

EXPOSE 3000
ENTRYPOINT [ "npm", "start" ]