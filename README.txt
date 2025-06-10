# Dart Breakout Game

This repository contains a simple Breakout game written in Dart and
served through Docker. The game runs in a browser using a canvas element.

## Running with Docker

Build the Docker image and run it:

```bash
docker build -t dart-breakout ./breakout
docker run -p 8080:80 dart-breakout
```

Then open `http://localhost:8080` in your browser to play the game.
