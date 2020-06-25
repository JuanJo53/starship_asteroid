import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';
/*Esta clase crea y renderiza el contador de puntos del jugador mientras esta jugando.*/
class ScoreCount{
  final GameController gameController;//GameController de donde obtenemos los puntos del jugador.
  TextPainter painter;
  Offset posicion;

  ScoreCount(this.gameController){
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );//Especificamos que text painter sera centreado, y diciendo que se escriba de izquierda a derecha.
    posicion = Offset.zero;//Su pocicion inicial
  }
  //Render del texto que muestra el contador de los puntos del jugador.
  void render(Canvas canvas){
    painter.paint(canvas, posicion);
  }
  //Cada vez que se incrementen los puntos, esta funcion lo actualiza y lo renderiza.
  void update(double t){
    //Si el texto que tiene el painter no sta vacio y es diferente al score actual del jugador, se actualiza.
    if((painter.text??'')!=gameController.score.toString()){
      painter.text=TextSpan(
        text: gameController.score.toString(),//Llamamos para mostrar los puntos del jugador mientras juega.
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          )
        );
        painter.layout();
        posicion=Offset(
          (gameController.screenSize.width/2)-(painter.width/2),//Horizontalmente al medio
          (gameController.screenSize.height*0.95)-(painter.height/2),//Verticalmente en la parte inferior (al 95% de la pantalla verticalmente.)
        );
    }
  }
}