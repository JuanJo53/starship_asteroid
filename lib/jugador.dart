import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class Jugador{
  final GameController gameController;
  
  Sprite nave;
  double vidaMaxima;
  double vidaActual;
  Rect jugadorRect;
  bool muerto=false;

  Jugador(this.gameController){
    Flame.images.loadAll(<String>[
      'nave.png',
    ]);
    vidaMaxima=vidaActual=300;
    final size =gameController.tileSize*1.5;
    jugadorRect=Rect.fromLTWH(gameController.screenSize.width/2-size/2, gameController.screenSize.height/2-size/2,size, size);
    nave=Sprite('rocket1.gif');
    
  }
 void render(Canvas canvas){
    Paint fondoPaint=Paint()..color=Colors.amber;    
    canvas.drawRect(jugadorRect, fondoPaint);
    final size =gameController.tileSize*5;
    nave.renderRect(canvas, Rect.fromLTWH(gameController.screenSize.width/2-size/2, gameController.screenSize.height/2-size/2,size, size));
  }
  void update(double t) {
    if(!muerto&&vidaActual<=0){
      muerto=true;      
    }
  }
}