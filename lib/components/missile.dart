import 'dart:math';
import 'dart:ui';

class Missle {
  Paint boxPaint;//Dibujo del misil
  double x;//Poscion en eje x
  double y;//Poscion en eje y
  double direction;//Direccion del misil
  double length;//Largo del misil
  double width;//Ancho del misil
  double speed;//Velocidad de desplazamiento del misil
  double dist;//Distancia del objetivo
  double blastRadius;
  bool destroyed;//Si el misil desaparece o no

  Missle(double init_x, double init_y, double init_direction, double init_distance, double init_blast_radius) {
    //Instanciamos las variables con los datos que se nos pasan de la clase "Missiles" al crear un misil nuevo
    x = init_x;
    y = init_y;
    direction = init_direction;
    dist = init_distance;
    blastRadius = init_blast_radius;

    length = 10;
    width =  0.1;
    speed = 4;
    destroyed = false;
  }
  //Aqui se renderiza al misil para mostrarlo como dibujo.
  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x, y)//Punto inicial del dibujo
      ..lineTo(x - cos(direction + width) * length, y - sin(direction + width) * length)//Linea un poco curveada hacia adelante abriendo la punta
      ..lineTo(x - cos(direction - width) * length, y - sin(direction - width) * length)//Linea un poco curveada hacia atras cerrando la punta
      ..lineTo(x, y);//Conecta con el punto inicial

    boxPaint = Paint();
    boxPaint.color = Color(0xff0004FA);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    canvas.drawPath(path, boxPaint);//Dibujamos el misil con su path y si forma definidos previamente
  }
  //Desplazamaiento del misil
  @override
  void update(double t) {
    x += cos(direction) * speed;//Desplazamaiento del misil en el eje x
    y += sin(direction) * speed;//Desplazamaiento del misil en el eje y
  }
  //Si el misil desaparece o no
  bool destroy() {
    destroyed = true;
    return destroyed;
  }
}