import 'dart:ffi';

import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class Jugador{
  final GameController gameController;
  
  double vidaMaxima;
  double vidaActual;
  Rect jugadorRect;
  bool muerto=false;

  Jugador(this.gameController){
    vidaMaxima=vidaActual=300;
    final size =gameController.tileSize*1.5;
    jugadorRect=Rect.fromLTWH(gameController.screenSize.width/2-size/2, gameController.screenSize.height/2-size/2,size, size);
  }
 void render(Canvas canvas){
    Paint fondoPaint=Paint()..color=Colors.amber;
    
    canvas.drawRect(jugadorRect, fondoPaint);
  }
  void update(double t) {
    if(!muerto&&vidaActual<=0){
      muerto=true;      
    }
  }
}