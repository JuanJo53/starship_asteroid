import 'dart:math';
import 'dart:ui';

class Explosion {
  Paint boxPaint;//Dinujo de la explosion
  double x;//Poscion en eje x
  double y;//Poscion en eje y
  double blastRadius;//Radio de la explosion del misil
  double maxBlastRadius;//Radio maximo de la explosion del misil
  double blastSpeed;//Velocidad

  Explosion(double init_x, double init_y, double init_blast_radius) {
    //Instanciamos las variables con los datos que se nos pasan de la clase "Explosions" al crear una explosion nueva
    x = init_x;
    y = init_y;
    maxBlastRadius = init_blast_radius;

    blastRadius = 0;
    blastSpeed = 0.2;
  }

  @override
  void render(Canvas canvas) {
    boxPaint = Paint();
    boxPaint.color = Color(0xffFAE700);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    Random rand = Random();
    //Se dibuja un ciruclo con un radio afectado por un valor aleatorio.
    canvas.drawCircle(Offset(x, y), rand.nextDouble() * blastRadius, boxPaint);
  }
  //La explosion se hace mas rapida
  @override
  void update(double t) {
    if (blastRadius < maxBlastRadius) {
      blastRadius += blastSpeed;
    }
  }
  //La explosion termina
  bool done() {
    return blastRadius >= maxBlastRadius;
  }
}