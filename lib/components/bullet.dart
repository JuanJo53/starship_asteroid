import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Bullet {
  Paint boxPaint;//Figura donde se dibujara la bala
  double x;//Posicion en eje x
  double y;//Posicion en eje y
  double direction;//Direccion a la que va la bala
  double size;//Tamaño de la bala
  double speed;//Velocidad de la bala
  bool destroyed;//Si la vala esta destruida o no (al choque con otro objeto)

  Bullet(double init_x, double init_y, double init_direction) {
    //Estos datos se nos pasa cuando se crea la bala desde la clase "Bullets"
    x = init_x;
    y = init_y;
    direction = init_direction;

    speed = 8;
    size = speed;
    destroyed = false;
  }

  @override
  void render(Canvas canvas) {
    //Dibujamos una linea simple, que representa la bala que dispara la nave.
    Path path = Path()
      ..moveTo(x, y)//Posicion en la punta de la nave como punto inicial
      ..lineTo(x + cos(direction) * size, y + sin(direction) * size);//Dibuja una linea hacia un poco mas adelante del punto inicial

    boxPaint = Paint();
    boxPaint.color = Colors.red;//Color de la linea=rojo
    boxPaint.style = PaintingStyle.stroke;//Aplica el dibujo a los bordes del tamaño de la figura
    boxPaint.strokeWidth = 2;//Tamaño del borde de la figura.

    canvas.drawPath(path, boxPaint);//Dibujamos con canvas, pasandole el Path y su BoxPaint de la bala.
  }

  @override
  void update(double t) {
    x += cos(direction) * speed;//Desplazamiento en el eje x dependiendo su velocidad y direccion
    y += sin(direction) * speed;//Desplazamiento en el eje y dependiendo su velocidad y direccion
  }
  //Esta funcion se llama cuando se quiere dejar de mostrar la bala
  bool destroy() {
    destroyed = true;
    return destroyed;
  }
}
