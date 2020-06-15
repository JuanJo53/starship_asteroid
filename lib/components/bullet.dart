import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Bullet {
  Rect boxRect;
  Paint boxPaint;
  double x;
  double y;
  double direction;
  double size;
  double speed;
  bool destroyed;

  Bullet(double init_x, double init_y, double init_direction) {
    x = init_x;
    y = init_y;
    direction = init_direction;
    speed = 8;
    size = speed;
    destroyed = false;
  }

  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x, y)
      ..lineTo(x + cos(direction) * size, y + sin(direction) * size);

    boxPaint = Paint();
    boxPaint.color = Colors.red;
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;
    canvas.drawPath(path, boxPaint);
  }

  @override
  void update(double t) {
    x += cos(direction) * speed;
    y += sin(direction) * speed;
  }

  bool destroy() {
    destroyed = true;
    return destroyed;
  }
}
