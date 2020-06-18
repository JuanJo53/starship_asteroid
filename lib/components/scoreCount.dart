import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class ScoreCount{
  final GameController gameController;
  TextPainter painter;
  Offset posicion;

  ScoreCount(this.gameController){
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
    if((painter.text??'')!=gameController.score.toString()){
      painter.text=TextSpan(
        text: gameController.score.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          )
        );
        painter.layout();
        posicion=Offset(
          (gameController.screenSize.width/2)-(painter.width/2),
          (gameController.screenSize.height*0.95)-(painter.height/2),
        );
    }
  }
}