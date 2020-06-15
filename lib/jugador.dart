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
  var rockets=['rocket_frame_0.png','rocket_frame_1.png','rocket_frame_3.png','rocket_frame_4.png','rocket_frame_5.png','rocket_frame_6.png'];

  Jugador(this.gameController){
    vidaMaxima=vidaActual=300;
    final size =gameController.tileSize*1.9;
    jugadorRect=Rect.fromLTWH(gameController.screenSize.width/2-size/2, gameController.screenSize.height/2-size/2,size, size);
    // nave=Sprite('rocket_frame_0.png');    
    // Flame.util.animationAsWidget(Position(WIDTH, HEIGHT), animation.Animation.sequenced('minotaur.png', AMOUNT, textureWidth: FRAME_WIDTH))
  }
 void render(Canvas canvas){
    Paint fondoPaint=Paint()..color=Colors.transparent;    
    canvas.drawRect(jugadorRect, fondoPaint);
    final size =gameController.tileSize*4;
    // nave.renderRect(canvas, Rect.fromLTWH(gameController.screenSize.width/1.95-size/2, gameController.screenSize.height/1.92-size/2,size, size));
  }
  void update(double t) {
    // rockets.forEach((rocket)=>nave=Sprite(rocket));
    if(!muerto&&vidaActual<=0){
      muerto=true;      
    }
  }
}