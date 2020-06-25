import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/asteroid.dart';
import 'package:starshipasteroid/components/missile.dart';
import 'package:audioplayers/audioplayers.dart';

class Missles {
  List<Asteroid> asteroids;//Lista de objetos Asteroid, de la clase "Asteroid"
  List<Missle> missles;//Lista de objetos Missile, de la clase "Missile"
  double x;//Posicion en el eje x
  double y;//Posicion en el eje y
  Function addExplosion;//Funcion para crear una explosion como tal que se pasa como parametro desde otra clase
  AudioPlayer shootAudio;//Audio para SFX de disparo de misil

  Missles(double init_x, double init_y, List<Asteroid> init_asteroids, Function init_add_explosion) {
    //Inicializamos las variables con los datos pasados desde la clase "GameController"
    x = init_x;
    y = init_y;
    addExplosion = init_add_explosion;
    asteroids = init_asteroids;

    //La lista de los misiles declarada como nueva lista
    missles = List<Missle>();
  }
  //Se renderiza cada misil en la lista de explosiones
  @override
  void render(Canvas canvas) {
    missles.forEach((Missle missle) => missle.render(canvas));
  }
  //Algun cambio de estado o posicion de los objetos
  @override
  void update(double t) {
    missles.forEach((Missle missle) => missle.update(t));//Cambio de posicion de los misiles
    missles.removeWhere((Missle missle) => this.exploded(missle) || missle.destroyed);//Se elimina los misiles de la lista de misiles si este ya exploto o o si se destruye

    // Deteccion de colision
    missles.forEach((Missle missle) => this.hasCollidedWithMany(missle, asteroids));
  }
  //Se crea nuevo misil y se la añade a la lista
  void addMissle(double dx, double dy) {
    double direction = atan2(dy - y, dx - x);
    double distance = sqrt(pow(dx - x, 2) + pow(dy - y, 2)); // * 2
    Missle missle = new Missle(x, y, direction, distance, 20);//Nueva explosion
    missles.add(missle);//Añade a lista
    soundShootMissile();//Suena el sonido de disparo
  }
  //Funcion que devuleve como booleano si el misil ya exploto o no 
  bool exploded(Missle object) {
    double distance = sqrt(pow(object.x - x, 2) + pow(object.y - y, 2));
    if (distance >= object.dist) {
      addExplosion(object.x, object.y, object.blastRadius);//Si el misil no fue destruido antes de llegar a su destino, explota
      return true;
    }
    return false;
  }
  //Esta funcion hace que se verifique al misil con todos los asteroides creados, llamando a la funcion donde se verifica si hubo colision
  void hasCollidedWithMany(Missle missle, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(missle, asteroid));
  }
  //Controla si hubo colision entre un misil y algun asteroide
  void hasCollided(Missle missle, Asteroid asteroid) {
    //Si el misil no esta dentro de la figura del asteroide
    if (missle.x - asteroid.x < asteroid.size && missle.y - asteroid.y < asteroid.size) {
      //Calcula la distacia entre el misil y algun asteroide
      double distBetween = sqrt(pow(missle.x - asteroid.x, 2) + pow(missle.y - asteroid.y, 2));
      //Si la distancia entre ambos es menor a la suma de sus tamaños (esto para representar cuando apenas se toquen)
      if (distBetween < asteroid.size) {
        missle.destroy();//Se destruye el misil
      }
    }
  }
  //Esta funcion reproduce el sonido del disparo de misil de assets/audio/
  void soundShootMissile()async{
    shootAudio = await Flame.audio.play('Shoot_Missile_SFX.mp3', volume: .25);//Suena SFX de disparo de misil
  }
}