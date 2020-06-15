import 'dart:math';
import 'dart:ui';

class Player {
  Rect boxRect;
  Paint boxPaint;
  double x;
  double y;
  double size;
  double angle;
  bool destroyed;

  Player(double init_x, double init_y) {
    x = init_x;
    y = init_y;

    angle = 0;
    size = 10;
    destroyed = false;
  }

  @override
  void render(Canvas canvas) {
    double tri = pi * 2 / 3;
    Path path = Path()
      ..moveTo(x + cos(angle) * size, y + sin(angle) * size)
      ..lineTo(x + cos(tri + angle) * size, y + sin(tri + angle) * size)
      ..lineTo(x + cos(tri * 1.5 + angle) * size / 4, y + sin(tri * 1.5 + angle) * size / 4)
      ..lineTo(x + cos(tri * 2 + angle) * size, y + sin(tri * 2 + angle) * size)
      ..lineTo(x + cos(angle) * size, y + sin(angle) * size);

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    canvas.drawPath(path, boxPaint);
  }

  @override
  void update(double t) {
  }

  void fireAt(double at_x, double at_y) {
    angle = atan2(at_y - y, at_x - x);
  }

  bool destroy() {
    destroyed = true;
    return destroyed;
  }
}
