# syntax=docker/dockerfile:1
ARG NODE_VERSION=21.6.2
FROM node:${NODE_VERSION}-alpine as base
WORKDIR /usr/src/app
FROM base as build
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci

COPY . .
RUN npm run build

FROM nginx:alpine AS final

COPY --from=build /usr/src/app/dist /usr/share/nginx/html/
EXPOSE 80
