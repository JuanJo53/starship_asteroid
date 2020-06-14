import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class BarraVida{
  final GameController gameController;
  Rect vidaRect;
  Rect restoVidaRect;

  BarraVida(this.gameController){
    double barWidth=gameController.screenSize.width/1.75;
    vidaRect=Rect.fromLTWH(gameController.screenSize.width/2-barWidth/2, gameController.screenSize.height*0.9, barWidth, gameController.tileSize*0.5);
    restoVidaRect=Rect.fromLTWH(gameController.screenSize.width/2-barWidth/2, gameController.screenSize.height*0.9, barWidth, gameController.tileSize*0.5);
  }
  void render(Canvas canvas){
    Paint vidaColor=Paint()..color=Colors.red;
    Paint restoVidaColor=Paint()..color=Colors.green;
    canvas.drawRect(vidaRect, vidaColor);
    canvas.drawRect(restoVidaRect, restoVidaColor);

  }

  void update(double t){
    double barWidth=gameController.screenSize.width/1.75;
    double porcentajeVida=gameController.nave.vidaActual/gameController.nave.vidaMaxima;
    restoVidaRect=Rect.fromLTWH(gameController.screenSize.width/2-barWidth/2, gameController.screenSize.height*0.9, barWidth*porcentajeVida, gameController.tileSize*0.5);

  }
}