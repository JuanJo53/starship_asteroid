import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starshipasteroid/components/scoreCount.dart';
import 'package:starshipasteroid/components/gameOver.dart';
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
  ScoreCount scoreCount;  
  AudioPlayer menuAudio;
  GoogleSignIn googleSignIn;
  String userid='';
  int currentHighscore=0;
  GameOver gameOver;

  GameController() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    asteroids = new Asteroids(screenSize.width, screenSize.height);
    bullets =  new Bullets(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    players = new Players(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, this.endGame, bullets.addBullet);
    gameOver=GameOver(this);

    inProgress = true;
    newGame = true;
    switchGunRadius = 20;
    gameEndedAt = 0;
    restartDelay = 1000;
    score=0;
    scoreCount=ScoreCount(this);
    startGame();
    await setUserId().then((value){
      userid=value;
    });
    await Firestore.instance.collection('usuarios').document(userid).get().then((doc){
      if(doc.exists){
        currentHighscore=doc.data['score'];
      }else{
        print('No se identifico al documento');
      }
    });
  }

  @override
  void render(Canvas canvas) {
    if(newGame){
      Rect fondo=Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
      Paint fondoPaint=Paint()..color=Colors.black;
      canvas.drawRect(fondo, fondoPaint);
      scoreCount.render(canvas);
      asteroids.render(canvas);
      bullets.render(canvas);
      players.render(canvas);
      scoreIncrement();
    }else{
      gameOver.render(canvas);
      print('not a new game');
    }
  }

  @override 
  void update(double t) {
    if(!paused){
      asteroids.update(t);
      bullets.update(t);
      players.update(t);
      scoreCount.update(t);     
    }
    if(!newGame){
      gameOver.update(t) ;
    }
  }
  void resize(Size size) {
    screenSize = size;
  }
  void startGame() {
    players.addPlayer();
    inProgress = true;
    newGame=true;
    asteroids.start();
  }
  void restartGame(){
    score=0;
    asteroids.asteroids.clear();
    players.players.clear();
    bullets.bullets.clear();
    asteroids.stop();
    newGame=true;
    startGame();
  }
  void endGame() {
    inProgress = false;
    asteroids.stop();
    gameEndedAt = DateTime.now().millisecondsSinceEpoch;
    newGame=false;
    if(currentHighscore<score){
      Firestore.instance.collection('usuarios').document(userid).updateData({
        'score': score,
      });
    }
  }

  void onTapDown(TapDownDetails d) {
    if (inProgress) {
      players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
    } else if (gameEndedAt < DateTime.now().millisecondsSinceEpoch - restartDelay) {
      // startGame();
      print('click');
    } 
  }
  void scoreIncrement(){
    // print(DateTime.now().second);
    if(inProgress){
      score++;
    }
  }
  Future<bool> signedIn() async {
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(user!=null){
      return true;
    }else{
      return false;
    }
  }
  Future<String> setUserId() async {
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(await signedIn()){
      return user.uid;
    }
  }
}
