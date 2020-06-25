import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/scoreCount.dart';
import 'package:starshipasteroid/components/gameOver.dart';
import 'package:starshipasteroid/systems/asteroids.dart';
import 'package:starshipasteroid/systems/bullets.dart';
import 'package:starshipasteroid/systems/players.dart';
// import 'package:wakelock/wakelock.dart';

//Esta clase controla todos los renders existentes cuando juega una nueva partida.
class GameController extends Game{

  bool paused=false; //Controla si el juego esta pausado o no
  bool newGame=false; //Verifica si es nuevo juego o no.
  Asteroids asteroids; //Declaracion del conjunto de Asteroides
  Bullets bullets; //Declaracion del conjunto de balas
  Players players; //Declaracion del conjunto de jugadores
  Size screenSize; //Declaracion del tamaño de la pantalla que usaremos
  bool inProgress; //Controla si el juego esta en curso o no.
  double switchGunRadius; 
  int score; // Ingrementador de puntos
  ScoreCount scoreCount; //Clase que muestra el contador de los puntos
  String userid=''; //Aqui se almacena el ID del documento del usuario loggeado
  int currentHighscore=0; //Aqui se almacena la puntuacion mas alta del jugador.
  GameOver gameOver; //Pantalla que se muestra cuando muere el jugador.

  GameController() {
    initialize();
  }
  //Aqui se inicializan todas las variables declaradas previamente (importantisimo).
  void initialize() async {
    resize(await Flame.util.initialDimensions());
    asteroids = new Asteroids(screenSize.width, screenSize.height);
    bullets =  new Bullets(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    players = new Players(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, this.endGame, bullets.addBullet);
    gameOver=GameOver(this);

    inProgress = true;
    newGame = true;
    switchGunRadius = 20;
    score=0;
    scoreCount=ScoreCount(this);
    startGame();//Apenas se entre a esta pantalla empieza el juego.

    //Obtenemos los valores del id del usuario que esta jugando y su puntaje mas alto actual.
    await setUserId().then((value){
      userid=value;//Seteamos el valor del ID
    });
    await Firestore.instance.collection('usuarios').document(userid).get().then((doc){
      if(doc.exists){
        currentHighscore=doc.data['score'];//Seteamos el valor del puntaje mas alto
      }else{
        print('No se identifico al documento');
      }
    });
  }
  //Aqui renderizamos todos los objetos si es que es un nuevo juego.
  @override
  void render(Canvas canvas) {
    if(newGame){
      //Si es un juego nuevo, renderiza todos los objetos del juego
      Rect fondo=Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
      Paint fondoPaint=Paint()..color=Colors.black;
      canvas.drawRect(fondo, fondoPaint);
      scoreCount.render(canvas);
      asteroids.render(canvas);
      bullets.render(canvas);
      players.render(canvas);
      scoreIncrement();
    }else{
      //Si no es un nuevo juego, muestra la pantalla de Game Over
      gameOver.render(canvas);
      print('not a new game');
    }
  }
  //Aqui se actualiza el render de cada objeto del juego.
  @override 
  void update(double t) {
    if(!paused){
      //Si no se pausó el juego, continua renderizando los cambios de los objetos del juego.
      asteroids.update(t);
      bullets.update(t);
      players.update(t);
      scoreCount.update(t);     
      //Si esta pausado, todos los objetos del juego se detienen.
    }
    if(!newGame){
      //Si es un juego nuevo, se actualiza la pantalla de Game Over
      gameOver.update(t) ;
    }
  }
  //Esta funcion se utiliza para determinar el tamaño de la pantalla.
  void resize(Size size) {
    screenSize = size;
  }
  //Funcion que inicia el juego 
  void startGame() {
    players.addPlayer();//Agrega al jugador
    inProgress = true;
    newGame=true;
    asteroids.start();//Los asteroides empizan a aparecer
  }
  //Resetea las listas de elementos del juego y los valores relevantes.
  void restartGame(){
    score=0;
    asteroids.asteroids.clear();
    players.players.clear();
    bullets.bullets.clear();
    asteroids.stop();//Los asteroides dejan de aparecer.
    newGame=true;
    startGame();//Vuelve a iniciar el juego.
  }
  //Termina el juego cuando el jugador muere.
  void endGame() {
    inProgress = false;
    newGame=false;
    asteroids.stop();//Los asteroides dejan de aparecer.
    //Verificamos si el puntaje de la ultima partida es mayor a su mayor puntaje del usuario.
    if(currentHighscore<score){
      Firestore.instance.collection('usuarios').document(userid).updateData({
        'score': score,
      });//De ser mayor, actualizamos la base de datos con el nuevo mayor puntaje.
    }
  }
  //Controla cuando se pulsa en la pantalla mientras se juega.
  void onTapDown(TapDownDetails d) {
    if (inProgress) {
      //Mandamos la posicion donde se presiono en la pantalla, para que dispare hacia esa direccion.
      players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
    } else{
      // startGame();
      //Si no se esta jugando, solo controlamos que isga capturando el evento de OnTapDown.
      print('click');
    } 
  }
  //Conforme pasa el tiempo, el puntaje debe ir incrementando.
  void scoreIncrement(){
    //Si no se pauso el juego, el puntaje sigue incrementando.
    if(inProgress){
      score++;
    }
  }
  //Esta funcion retorna un booleano que indica si hay un usuario autenticado.
  Future<bool> signedIn() async {
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(user!=null){
      return true;
    }else{
      return false;
    }
  }
  //Retorna el ID del usuario autenticado.
  Future<String> setUserId() async {
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(await signedIn()){
      return user.uid;
    }
  }
}