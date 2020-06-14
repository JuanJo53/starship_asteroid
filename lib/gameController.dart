import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameController extends Game{
  Size screenSize;
  double tileSize;
  GameController(){
    inicialize();
  }

  void inicialize() async{
    resize(await Flame.util.initialDimensions());
  }
  void render(Canvas canvas){
    Rect fondo=Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint fondoPaint=Paint()..color=Colors.black;

    canvas.drawRect(fondo, fondoPaint);
  }
  void update(double t) {
    // TODO: implement update
  }
  void resize(Size size) {
    screenSize=size;
    tileSize=screenSize.width/10;
  }

}