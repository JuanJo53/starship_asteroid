import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/asteroid.dart';
import 'package:starshipasteroid/barraVida.dart';

import 'jugador.dart';

class GameController extends Game{

  Size screenSize;
  double tileSize;
  Jugador nave;
  List<Asteroid> asts;
  BarraVida barraVida;
  Sprite naveSprt = Sprite('nave.png');
  Random rand;
  GameController(){
    inicialize();
  }

  void inicialize() async{
    resize(await Flame.util.initialDimensions());
    nave=Jugador(this);
    asts=List<Asteroid>();
    barraVida=BarraVida(this);
  }
  void render(Canvas canvas){
    Rect fondo=Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint fondoPaint=Paint()..color=Colors.black;
    canvas.drawRect(fondo, fondoPaint);
    Flame.images.load('nave.png').then((Image image) {
      var paint = Paint()..color = Color(0xffffffff);
      var rect = Rect.fromLTWH(0.0, 0.0, image.width.toDouble(), image.height.toDouble());
      canvas.drawImageRect(image, rect, rect, paint);
    });
    // naveSprt.render(canvas);
    nave.render(canvas);
    asts.forEach((Asteroid asteroid)=>asteroid.render(canvas));
    barraVida.render(canvas);
  }
  void update(double t) {
    asts.forEach((Asteroid asteroid)=>asteroid.update(t));
    nave.update(t);
    barraVida.update(t);
  }
  void resize(Size size) {
    screenSize=size;
    tileSize=screenSize.width/10;
  }
  void onTapDown(TapDownDetails down){
    print(down.globalPosition);
    asts.forEach((Asteroid asteroid){
      if(asteroid.asteroidRect.contains(down.globalPosition)){
        asteroid.onTapDown();
      }
    });
  }
  void spawnAsteroid(){
    double x,y;
    switch (rand.nextInt(4)){
      case 0:

      case 1:
      case 2:
      case 3:
    }
  }
}