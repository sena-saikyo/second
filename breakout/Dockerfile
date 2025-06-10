# Build stage
FROM dart:stable AS build
WORKDIR /app
COPY pubspec.yaml ./
RUN dart pub get
COPY . .
RUN dart compile js -O2 -o /app/web/main.dart.js web/main.dart

# Serve stage
FROM nginx:alpine
COPY --from=build /app/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
