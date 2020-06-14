import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class ContadorPuntos{
  final GameController gameController;
  TextPainter painter;
  Offset posicion;

  ContadorPuntos(this.gameController){
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    posicion = Offset.zero;
  }

  void render(Canvas canvas){
    painter.paint(canvas, posicion);
  }

  void update(double t){
    if((painter.text??'')!=gameController.puntos.toString()){
      painter.text=TextSpan(
        text: gameController.puntos.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 70.0,
          )
        );
        painter.layout();
        posicion=Offset(
          (gameController.screenSize.width/2)-(painter.width/2),
          (gameController.screenSize.height*0.2)-(painter.height/2),
        );
    }
  }

}