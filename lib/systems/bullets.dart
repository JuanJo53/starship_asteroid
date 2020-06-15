import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/asteroid.dart';
import 'package:starshipasteroid/components/bullet.dart';
import 'package:audioplayers/audioplayers.dart';
class Bullets {
  List<Bullet> bullets;
  List<Asteroid> asteroids;
  double x;
  double y;
  
  AudioPlayer shootAudio;

  Bullets(double init_x, double init_y, List<Asteroid> init_asteroids) {
    x = init_x;
    y = init_y;

    bullets = List<Bullet>();
    asteroids = init_asteroids;
  }

  @override
  void render(Canvas canvas) {
    bullets.forEach((Bullet bullet) => bullet.render(canvas));
  }

  @override
  void update(double t) {
    bullets.forEach((Bullet bullet) => bullet.update(t));
    bullets.removeWhere((Bullet bullet) => this.offScreen(bullet));

    bullets.forEach((Bullet bullet) => this.hasCollidedWithMany(bullet, asteroids));
    bullets.removeWhere((Bullet bullet) => bullet.destroyed);
  }

  void hasCollidedWithMany(Bullet bullet, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(bullet, asteroid));
  }

  void hasCollided(Bullet bullet, Asteroid asteroid) {
    if (bullet.x - asteroid.x < asteroid.size && bullet.y - asteroid.y < asteroid.size) {
      double distBetween = sqrt(pow(bullet.x - asteroid.x, 2) + pow(bullet.y - asteroid.y, 2));
      if (distBetween < asteroid.size) {
        bullet.destroy();
        asteroid.hit(0.75);
      }
    }
  }

  Future<void> addBullet(double dx, double dy) async {
    double direction = atan2(dy - y, dx - x);
    Bullet bullet = new Bullet(x, y, direction);
    bullets.add(bullet);
    shootAudio = await Flame.audio.play('Laser_Gun_SFX.mp3', volume: .25);
  }

  bool offScreen(Bullet object) {
    if (object.x < 0 || object.y < 0 || object.x > x * 2 || object.y > y * 2) {
      return true;
    }
    return false;
  }
}
