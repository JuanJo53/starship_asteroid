import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:starshipasteroid/systems/asteroids.dart';
import 'package:starshipasteroid/systems/bullets.dart';
import 'package:starshipasteroid/systems/players.dart';
// import 'package:wakelock/wakelock.dart';

class GameController extends Game{

  bool paused=false;
  bool newGame=false;
  Asteroids asteroids;
  Bullets bullets;
  Players players;
  Size screenSize;
  bool inProgress;
  double switchGunRadius;
  int gameEndedAt;
  int restartDelay;
  int score;  
  AudioPlayer menuAudio;

  GameController() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    asteroids = new Asteroids(screenSize.width, screenSize.height);
    bullets =  new Bullets(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    players = new Players(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, this.endGame, bullets.addBullet);

    inProgress = true;
    newGame = true;
    switchGunRadius = 20;
    gameEndedAt = 0;
    restartDelay = 1000;
    score=0;
    startGame();
    // scoreCount=scoreCount(this);
  }

  @override
  void render(Canvas canvas) {
    Rect fondo=Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint fondoPaint=Paint()..color=Colors.black;
    canvas.drawRect(fondo, fondoPaint);
    asteroids.render(canvas);
    bullets.render(canvas);
    players.render(canvas);
  }

  @override 
  void update(double t) {
    if(!paused){
      asteroids.update(t);
      bullets.update(t);
      players.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
  }

  void startGame() {
    players.addPlayer();
    inProgress = true;
    asteroids.start();
  }

  void endGame() {
    inProgress = false;
    asteroids.stop();
    gameEndedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onTapDown(TapDownDetails d) {
    if (inProgress) {
      // double distFromCenter = sqrt(pow(screenSize.width / 2 - d.globalPosition.dx, 2) + pow(screenSize.height / 2 - d.globalPosition.dy, 2));
      // if (distFromCenter <= switchGunRadius) {
      //    players.switchGun();
      // } else {
      //    players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
      // }
      players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
    } else if (gameEndedAt < DateTime.now().millisecondsSinceEpoch - restartDelay) {
      // startGame();
      print('click');
    }   
  }
  void restartGame(){
    score=0;
    asteroids.asteroids.clear();
    players.players.clear();
    bullets.bullets.clear();
    asteroids.stop();
    startGame();
  }

}