import 'dart:html';
import 'dart:async';

late CanvasRenderingContext2D ctx;
late CanvasElement canvas;

const ballRadius = 10;
late num x;
late num y;
num dx = 2;
num dy = -2;

const paddleHeight = 10;
const paddleWidth = 75;
late num paddleX;

bool rightPressed = false;
bool leftPressed = false;

const brickRowCount = 3;
const brickColumnCount = 5;
const brickWidth = 75;
const brickHeight = 20;
const brickPadding = 10;
const brickOffsetTop = 30;
const brickOffsetLeft = 30;

List<List<Map<String, dynamic>>> bricks = List.generate(
    brickColumnCount,
    (_) => List.generate(brickRowCount, (_) => {'x': 0, 'y': 0, 'status': 1}));

int score = 0;

void drawBall() {
  ctx.beginPath();
  ctx.arc(x, y, ballRadius, 0, 3.14159 * 2);
  ctx.fillStyle = '#0095DD';
  ctx.fill();
  ctx.closePath();
}

void drawPaddle() {
  ctx.beginPath();
  ctx.rect(paddleX, canvas.height! - paddleHeight, paddleWidth, paddleHeight);
  ctx.fillStyle = '#0095DD';
  ctx.fill();
  ctx.closePath();
}

void drawBricks() {
  for (var c = 0; c < brickColumnCount; c++) {
    for (var r = 0; r < brickRowCount; r++) {
      if (bricks[c][r]['status'] == 1) {
        var brickX = (c * (brickWidth + brickPadding)) + brickOffsetLeft;
        var brickY = (r * (brickHeight + brickPadding)) + brickOffsetTop;
        bricks[c][r]['x'] = brickX;
        bricks[c][r]['y'] = brickY;
        ctx.beginPath();
        ctx.rect(brickX, brickY, brickWidth, brickHeight);
        ctx.fillStyle = '#0095DD';
        ctx.fill();
        ctx.closePath();
      }
    }
  }
}

void drawScore() {
  ctx.font = '16px Arial';
  ctx.fillStyle = '#0095DD';
  ctx.fillText('Score: $score', 8, 20);
}

void collisionDetection() {
  for (var c = 0; c < brickColumnCount; c++) {
    for (var r = 0; r < brickRowCount; r++) {
      var b = bricks[c][r];
      if (b['status'] == 1) {
        if (x > b['x'] && x < b['x'] + brickWidth &&
            y > b['y'] && y < b['y'] + brickHeight) {
          dy = -dy;
          b['status'] = 0;
          score++;
          if (score == brickRowCount * brickColumnCount) {
            window.alert('YOU WIN, CONGRATS!');
            window.location.reload();
          }
        }
      }
    }
  }
}

void draw(Timer t) {
  ctx.clearRect(0, 0, canvas.width!, canvas.height!);
  drawBricks();
  drawBall();
  drawPaddle();
  drawScore();
  collisionDetection();

  if (x + dx > canvas.width! - ballRadius || x + dx < ballRadius) {
    dx = -dx;
  }
  if (y + dy < ballRadius) {
    dy = -dy;
  } else if (y + dy > canvas.height! - ballRadius) {
    if (x > paddleX && x < paddleX + paddleWidth) {
      dy = -dy;
    } else {
      window.alert('GAME OVER');
      window.location.reload();
    }
  }

  x += dx;
  y += dy;

  if (rightPressed && paddleX < canvas.width! - paddleWidth) {
    paddleX += 7;
  } else if (leftPressed && paddleX > 0) {
    paddleX -= 7;
  }
}

void keyDownHandler(KeyboardEvent e) {
  if (e.keyCode == KeyCode.RIGHT) {
    rightPressed = true;
  } else if (e.keyCode == KeyCode.LEFT) {
    leftPressed = true;
  }
}

void keyUpHandler(KeyboardEvent e) {
  if (e.keyCode == KeyCode.RIGHT) {
    rightPressed = false;
  } else if (e.keyCode == KeyCode.LEFT) {
    leftPressed = false;
  }
}

void mouseMoveHandler(MouseEvent e) {
  var relativeX = e.client.x - canvas.getBoundingClientRect().left;
  if (relativeX > 0 && relativeX < canvas.width!) {
    paddleX = relativeX - paddleWidth / 2;
  }
}

void main() {
  canvas = querySelector('#gameCanvas') as CanvasElement;
  ctx = canvas.context2D;
  x = canvas.width! / 2;
  y = canvas.height! - 30;
  paddleX = (canvas.width! - paddleWidth) / 2;

  document.onKeyDown.listen(keyDownHandler);
  document.onKeyUp.listen(keyUpHandler);
  document.onMouseMove.listen(mouseMoveHandler);

  Timer.periodic(Duration(milliseconds: 10), draw);
}
