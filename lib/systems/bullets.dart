import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/asteroid.dart';
import 'package:starshipasteroid/components/bullet.dart';
import 'package:audioplayers/audioplayers.dart';
class Bullets {
  List<Bullet> bullets;//Lista de objetos Bullet, de la clase "Bullet"
  List<Asteroid> asteroids;//Lista de objetos Asteroid, de la clase "Asteroid"
  double x;//Posicion en el eje x
  double y;//Posicion en el eje y
  
  AudioPlayer shootAudio;//Audio para SFX de disparo laser

  Bullets(double init_x, double init_y, List<Asteroid> init_asteroids) {
    x = init_x;//Posicion donde estara la nave en el eje x
    y = init_y;//Posicion donde estara la nave en el eje y

    bullets = List<Bullet>();
    asteroids = init_asteroids;//Aqui se hace referencia la lista ya creada en el gameController de asteroides
  }
  //Se renderiza cada bala en la lista de balas
  @override
  void render(Canvas canvas) {
    bullets.forEach((Bullet bullet) => bullet.render(canvas));
  }
  //Algun cambio de estado o posicion de los objetos
  @override
  void update(double t) {
    bullets.forEach((Bullet bullet) => bullet.update(t));//Se hace el update de cada bala
    bullets.removeWhere((Bullet bullet) => this.offScreen(bullet));//Se elimina de la lista de balas todos los que esten fuera de la pantalla
    
    //Aqui se verifica si la bala choco con algun asteroide, se verifica con cada astroide creado
    bullets.forEach((Bullet bullet) => this.hasCollidedWithMany(bullet, asteroids));
    bullets.removeWhere((Bullet bullet) => bullet.destroyed);//Se elimina de la lista de balas todos los que esten destruidos
  }
  //Esta funcion hace que se verifique a la bala con todos los asteroides creados, llamando a la funcion donde se verifica si hubo colision
  void hasCollidedWithMany(Bullet bullet, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(bullet, asteroid));
  }
  //Controla si hubo colision entre alguna bala con un asteroide
  void hasCollided(Bullet bullet, Asteroid asteroid) {
    //Si la bala no se encuentra dentro del asteroide.
    if (bullet.x - asteroid.x < asteroid.size && bullet.y - asteroid.y < asteroid.size) {
      double distBetween = sqrt(pow(bullet.x - asteroid.x, 2) + pow(bullet.y - asteroid.y, 2));//Calcula la distancia entre el asteroide y la bala
      //Si la distancia entre ambos es menor a la suma de sus tamaños (esto para representar cuando apenas se toquen)
      if (distBetween < asteroid.size) {
        bullet.destroy();//Se destruye la bala porque hubo colision
        asteroid.hit(0.75);//Le aplicamos daño al asteroide, reduciendo su tamaño
      }
    }
  }
  //Crea una nueva bala con una posicion inicial y una direccion, y se lo añade a la lista
  Future<void> addBullet(double dx, double dy) async {
    double direction = atan2(dy - y, dx - x);//direccion dependiendo a donde se presiono en la pantalla
    Bullet bullet = new Bullet(x, y, direction);//crea nueva bala
    bullets.add(bullet);//añade a la lista de balas
    shootAudio = await Flame.audio.play('Laser_Gun_SFX.mp3', volume: .25);//Suena SFX de laser
  }
  //Devuelve como booleano si la bala se salio de la pantalla o no
  bool offScreen(Bullet object) {
    if (object.x < 0 || object.y < 0 || object.x > x * 2 || object.y > y * 2) {
      return true;
    }
    return false;
  }
}
