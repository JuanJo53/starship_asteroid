import 'dart:math';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/asteroid.dart';
import 'package:starshipasteroid/components/player.dart';

class Players {
  List<Asteroid> asteroids;//Lista de objetos Asteroid, de la clase "Asteroid"
  List<Player> players;//Lista de objetos player, de la clase "Player"
  double x;//Posicion en el eje x
  double y;//Posicion en el eje y
  Function endGame;//Funcion para terminar el juego que se pasa como parametro desde otra clase
  Function addBullet;//Funcion para crear una bala que se pasa como parametro desde otra clase
  Function addProjectile;//Funcion para crear un proyectil como tal que se pasa como parametro desde otra clase

  Players(double init_x, double init_y, List<Asteroid> init_asteroids, Function end_game, Function add_bullet) {
    x = init_x;//Posicion donde estara la nave en el eje x
    y = init_y;//Posicion donde estara la nave en el eje y
    endGame = end_game;
    addBullet = add_bullet;

    players = List<Player>();
    asteroids = init_asteroids;//Aqui se hace referencia la lista ya creada en el gameController de asteroides

    addProjectile = addBullet;
  }
  //Se renderiza cada jugador en la lista de jugadores
  @override
  void render(Canvas canvas) {
    players.forEach((Player player) => player.render(canvas));
  }
  //Algun cambio de estado o posicion de los objetos
  @override
  void update(double t) {
    players.forEach((Player player) => player.update(t));//Se hace el update de cada jugador
    players.removeWhere((Player player) => player.destroyed);//Se elimina de la lista de jugadores todos los que esten destruidos

    //Aqui se verifica si el jugador choco con algun asteroide, se verifica con cada astroide creado
    players.forEach((Player player) => this.hasCollidedWithMany(player, asteroids));
  }
  //Crea un nuevo jugador con una posicion inicial, y se lo añade a la lista
  void addPlayer() {
    Player player = new Player(x, y);
    players.add(player);
  }
  //Crea un proyectil y lo dispara hacia la posicion donde se presiono en la pantalla
  bool fireAt(double dx, double dy) {
    players.forEach((Player player) => player.fireAt(dx, dy));
    addProjectile(dx, dy);
    return players.length > 0;
  }
  //Esta funcion hace que se verifique al jugador con todos los asteroides creados, llamando a la funcion donde se verifica si hubo colision
  void hasCollidedWithMany(Player player, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(player, asteroid));
  }
  //Controla si hubo colision entre el jugador y algun asteroide
  void hasCollided(Player player, Asteroid asteroid) {
    //Si el jugador no se encuentra dentro del asteroide.
    if (player.x - asteroid.x < player.size + asteroid.size && player.y - asteroid.y < player.size + asteroid.size) {
      double distBetween = sqrt(pow(player.x - asteroid.x, 2) + pow(player.y - asteroid.y, 2));//Calcula la distancia entre el asteroide y la nave(jugador)
      //Si la distancia entre ambos es menor a la suma de sus tamaños (esto para representar cuando apenas se toquen)
      if (distBetween < player.size + asteroid.size) {
        player.destroy();//Nave (jugador) se destruye porque hubo colision
        endGame();//El juego termina
      }
    }
  }
}
