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

  bool pausado=false;
  bool nuevoJuego=false;
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

    inProgress = false;
    switchGunRadius = 20;
    gameEndedAt = 0;
    restartDelay = 1000;
    score=0;
    // scoreCount=scoreCount(this);
    //https://jap.alekhin.io/scoring-storage-sound-tutorial-flame-flutter-part-4
    // menuAudio = await Flame.audio.loopLongAudio('Space_Game_Loop.mp3', volume: .25);
    // menuAudio.pause();
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
    if(!pausado){
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
      //   // players.switchGun();
      // } else {
      //    players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
      // }
      players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
    } else if (gameEndedAt < DateTime.now().millisecondsSinceEpoch - restartDelay) {
      startGame();
    }   
  }
  void restartGame(){
    score=0;
    asteroids.asteroids.clear();
    asteroids.stop();
    startGame();
  }
  // bool pausado=false;
  // bool nuevoJuego=false;
  // Size screenSize;
  // double tileSize;
  // Jugador nave;
  // List<Asteroid> asts;
  // BarraVida barraVida;
  // AudioPlayer menuAudio;
  // Sprite naveSprt = Sprite('cohete-blanco-naranja.png');
  // Random rand;
  // AsteroidSpawner spawner;
  // int puntos;
  // ContadorPuntos contador;
  
  // GameController(){
  //     inicialize();
  //   // if(nuevoJuego==true){
  //   // }
  // }

  // void inicialize() async{
  //   resize(await Flame.util.initialDimensions());
  //   rand=Random();
  //   nave=Jugador(this);
  //   asts=List<Asteroid>();
  //   spawner=AsteroidSpawner(this);
  //   barraVida=BarraVida(this);
  //   puntos=0;
  //   contador=ContadorPuntos(this);
  //   //https://jap.alekhin.io/scoring-storage-sound-tutorial-flame-flutter-part-4
  //   menuAudio = await Flame.audio.loopLongAudio('Space_Game_Loop.mp3', volume: .25);
  //   menuAudio.pause();
  // }
  // void render(Canvas canvas){
  //   Rect fondo=Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
  //   Paint fondoPaint=Paint()..color=Colors.transparent;
  //   canvas.drawRect(fondo, fondoPaint);
  //   nave.render(canvas);
  //   asts.forEach((Asteroid asteroid)=>asteroid.render(canvas));
  //   contador.render(canvas);
  //   barraVida.render(canvas);
  // }
  // void update(double t) {    
  //   if(pausado==false){
  //     spawner.update(t);
  //     asts.forEach((Asteroid asteroid)=>asteroid.update(t));
  //     asts.removeWhere((Asteroid asteroid)=>asteroid.destruido);
  //     nave.update(t);
  //     contador.update(t);
  //     barraVida.update(t);
  //   }
  // }
  // void resize(Size size) {
  //   screenSize=size;
  //   tileSize=screenSize.width/10;
  // }
  // void onTapDown(TapDownDetails down){
  //   print(down.globalPosition);
  //   asts.forEach((Asteroid asteroid){
  //     if(asteroid.asteroidRect.contains(down.globalPosition)){
  //       asteroid.onTapDown();
  //     }
  //   });
  // }
  // void spawnAsteroid(){
  //   double x,y;
  //   switch (rand.nextInt(4)){
  //     case 0:
  //       x=rand.nextDouble()*screenSize.width;
  //       y=-tileSize*2.5;
  //       break;
  //     case 1:
  //       x=screenSize.width+tileSize*2.5;
  //       y=rand.nextDouble()*screenSize.width;
  //       break;
  //     case 2:
  //       x=rand.nextDouble()*screenSize.width;
  //       y=screenSize.height+tileSize*2.5;
  //       break;
  //     case 3:
  //       x=-tileSize*2.5;
  //       y=rand.nextDouble()*screenSize.height;
  //       break;
  //   }
  //   asts.add(Asteroid(this,x,y));
  // }
  // void restartGame(){
  //   puntos=0;
  //   asts.clear();
  //   nave.vidaActual=nave.vidaMaxima;
  //   nave.muerto=false;
  // }

}