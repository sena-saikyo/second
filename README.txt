# Dart Breakout Game

This repository contains a simple Breakout game written in Dart and
served through Docker. The game runs in a browser using a canvas element.

## Running with Docker

Build the Docker image and run it manually:

```bash
docker build -t dart-breakout ./breakout
docker run -p 8080:80 dart-breakout
```

Then open `http://localhost:8080` in your browser to play the game.

## Running with Docker Compose

Alternatively, you can use Docker Compose. This will build the image
and start the container with a single command:

```bash
docker compose up --build
```

After it starts, open `http://localhost:8080` in your browser to play
the game.
