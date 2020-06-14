import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class Asteroid{
  final GameController gameController;
  int vida;
  double damage;
  double speed;
  Rect asteroidRect;
  bool destruido=false;

  Asteroid(this.gameController,double x, double y){
    vida=3;
    damage=1;
    speed=gameController.tileSize*2;
    asteroidRect=Rect.fromLTWH(x, y, gameController.tileSize*1.2, gameController.tileSize*1*2);
  }
  void render(Canvas canvas){
    Color color;
    switch (vida){
      case 1:
        color=Colors.red;
        break;
      case 2:
        color=Colors.yellow;
        break;
      case 3:
        color=Colors.blue;
        break;
      default:
        color=Colors.green;
        break;
    }
    Paint colorAst=Paint()..color=color;
    canvas.drawRect(asteroidRect, colorAst);
  }

  void update(double t){
    if(!destruido){
      double distancia=speed*t;
      Offset aNave=gameController.nave.jugadorRect.center-asteroidRect.center;
      if(distancia<=aNave.distance-gameController.tileSize*1.25){
        Offset distanciaNave=Offset.fromDirection(aNave.direction,distancia);
        asteroidRect=asteroidRect.shift(distanciaNave);
      }else{
        doesDamage();
      }
    }
  }
  void doesDamage(){
    if(!gameController.nave.muerto){
      gameController.nave.vidaActual-=damage;
    }
  }
  void onTapDown(){
    if(!destruido){
      vida--;
      if(vida<=0){
        destruido=true;
        //Aqui sera el control de los puntos respecto al tipo de asteroide.
        gameController.puntos++;
        
      }
    }
  }
  

}