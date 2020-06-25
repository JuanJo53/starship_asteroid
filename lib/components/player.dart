import 'dart:math';
import 'dart:ui';

class Player {
  Paint boxPaint;//Pain donde se dibuja el jugador
  double x;//Posicion en eje x
  double y;//Posicion en eje y
  double size;//Tamaño del jugador
  double angle;//Angulo a donde mira el jugador
  bool destroyed;//Si esta muerto o no el jugador

  Player(double init_x, double init_y) {
    //Estos datos nos los envian al iniciar el juego y agregar al jugador desde la clase Players.
    x = init_x;
    y = init_y;
    
    angle = 0;
    size = 10;
    destroyed = false;
  }
  //Aqui se renderizara todo lo que dibujemos con canvas.
  @override
  void render(Canvas canvas) {
    double tri = pi * 2 / 3;//Se define el valor de cambio de direccion para dibujar un triangulo.

    //Aqui empezamos a dibujar al jugador, siguiendo un path.
    Path path = Path()
      ..moveTo(x + cos(angle) * size, y + sin(angle) * size)//Punto inicial del dibujo
      ..lineTo(x + cos(tri + angle) * size, y + sin(tri + angle) * size)//Primera linea marcando la punta de la nave
      ..lineTo(x + cos(tri * 1.5 + angle) * size / 4, y + sin(tri * 1.5 + angle) * size / 4)//Linea en sentido contrario terminando de dibujar la punta.
      ..lineTo(x + cos(tri * 2 + angle) * size, y + sin(tri * 2 + angle) * size)//Linea al centro y un poco adentro del triangulo
      ..lineTo(x + cos(angle) * size, y + sin(angle) * size);//Conectamos con el punto incial del dibujo.

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);//Color del dibujo=Blanco
    boxPaint.style = PaintingStyle.stroke;//Aplica el dibujo a los bordes del tamaño de la figura
    boxPaint.strokeWidth = 2;//Tamaño del borde de la figura.

    canvas.drawPath(path, boxPaint);//Dibujamos con canvas, pasandole el Path y su BoxPaint del dibujo.
  }

  @override
  void update(double t) {
  }
  //Aqui se realiza la rotacion del jugador en base a la posicion donde el usuario presiona en la pantalla.
  void fireAt(double at_x, double at_y) {
    angle = atan2(at_y - y, at_x - x);//Cambiamos el angulo a donde apunta la nave.
  }
  //Cuando el jugador muere se llama a esta funcion.
  bool destroy() {  
    destroyed = true;
    return destroyed;
  }
}
