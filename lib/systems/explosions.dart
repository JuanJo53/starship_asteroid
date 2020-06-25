import 'dart:math';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/asteroid.dart';
import 'package:starshipasteroid/components/explosion.dart';

class Explosions {
  List<Asteroid> asteroids;//Lista de objetos Asteroid, de la clase "Asteroid"
  List<Explosion> explosions;//Lista de objetos Explosion, de la clase "Explosion"
  double x;//Posicion en el eje x
  double y;//Posicion en el eje y

  Explosions(double init_x, double init_y, List<Asteroid> init_asteroids) {
    //Inicializamos las variables con los datos pasados desde la clase "GameController"
    x = init_x;
    y = init_y;
    asteroids = init_asteroids;
    //Creamos como nueva lista de explosiones
    explosions = List<Explosion>();
  }
  //Se renderiza cada explosion en la lista de explosiones
  @override
  void render(Canvas canvas) {
    explosions.forEach((Explosion explosion) => explosion.render(canvas));
  }
  //Algun cambio de estado o posicion de los objetos
  @override
  void update(double t) {
    explosions.forEach((Explosion explosion) => explosion.update(t));//Cambio de posicion de las explosiones
    explosions.removeWhere((Explosion explosion) => explosion.done());//Se elimina una explosion de la lista de explosiones si esta ya termino de explotar

    // Deteccion de colision
    explosions.forEach((Explosion explosion) => this.hasCollidedWithMany(explosion, asteroids));
  }
  //Se crea nueva explosion y se la añade a la lista
  void addExplosion(double dx, double dy, double blastRadius) {
    Explosion explosion = new Explosion(dx, dy, blastRadius);//Nueva explosion
    explosions.add(explosion);//Añade a lista
  }
  //Esta funcion hace que se verifique a la explosion con todos los asteroides creados, llamando a la funcion donde se verifica si hubo colision
  void hasCollidedWithMany(Explosion explosion, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(explosion, asteroid));
  }
  //Controla si hubo colision entre e la explosion y algun asteroide
  void hasCollided(Explosion explosion, Asteroid asteroid) {
    //Si el asteroide no esta dentro del radio de la explosion
    if (explosion.x - asteroid.x < explosion.blastRadius + asteroid.size && explosion.y - asteroid.y < explosion.blastRadius + asteroid.size) {
      //Calcula la distacia entre la explosion y algun asteroide
      double distBetween = sqrt(pow(explosion.x - asteroid.x, 2) + pow(explosion.y - asteroid.y, 2));
      //Si la distancia entre ambos es menor a la suma de sus tamaños (esto para representar cuando apenas se toquen)
      if (distBetween < explosion.blastRadius + asteroid.size) {
        asteroid.hit(1);//Le aplicamos daño al asteroide, reduciendo su tamaño
      }
    }
  }
}