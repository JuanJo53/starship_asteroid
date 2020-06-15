import 'dart:math';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/asteroid.dart';

class Asteroids {
  List<Asteroid> asteroids;
  double spawnRadius; 
  double boundRadius; 
  double directionNoise; 
  double spawnRate;
  double minSpawnRate;
  double maxSpawnRate;
  double spawnGrowthRate;
  double sizeWidth;
  double sizeHeight;
  bool running;

  Asteroids(double init_sizeWidth, double init_sizeHeight) {
    sizeWidth = init_sizeWidth;
    sizeHeight = init_sizeHeight;

    asteroids = List<Asteroid>();
    spawnRadius = (sizeWidth + sizeHeight) / 2;
    boundRadius = spawnRadius + 10;
    directionNoise = 0.8;
    minSpawnRate = 0.01;
    maxSpawnRate = 0.1;
    spawnGrowthRate = 0.002 / 60; 
    spawnRate = minSpawnRate;
    running = false;
  }

  @override
  void render(Canvas canvas) {
    asteroids.forEach((Asteroid asteroid) => asteroid.render(canvas));
  }

  @override
  void update(double t) {
    Random rand = Random();
    if (rand.nextDouble() < spawnRate) {
      double location = rand.nextDouble() * pi * 2;
      double x = sizeWidth / 2 + cos(location) * spawnRadius;
      double y = sizeHeight / 2 + sin(location) * spawnRadius;
      double direction = atan2(sizeHeight / 2 - y, sizeWidth / 2 - x) + rand.nextDouble() * directionNoise * 2 - directionNoise;
      Asteroid asteroid = new Asteroid(x, y, direction);
      asteroids.add(asteroid);
    }

    if (running && spawnRate < maxSpawnRate) {
      spawnRate += spawnGrowthRate;
    }

    asteroids.forEach((Asteroid asteroid) => asteroid.update(t));
    asteroids.removeWhere((Asteroid asteroid) => this.offScreen(asteroid) || asteroid.destroyed);

    asteroids.forEach((Asteroid asteroid) => this.hasCollidedWithMany(asteroid, asteroids));
  }
  void resetAsteroids(){
    asteroids.clear();
  }

  void hasCollidedWithMany(Asteroid object_a, List<Asteroid> objects) {
    objects.forEach((Asteroid object_b) => this.hasCollided(object_a, object_b));
  }

  void hasCollided(Asteroid object_a, Asteroid object_b) {
    double distToHit = object_a.size + object_b.size;
    if (object_a.x - object_b.x < distToHit && object_a.y - object_b.y < distToHit) {
      double distBetween = sqrt(pow(object_a.x - object_b.x, 2) + pow(object_a.y - object_b.y, 2));
      if (object_a != object_b && distBetween < distToHit) {
        object_a.hit(0.5);
        object_b.hit(0.5);
        
        double angle = atan2(object_a.y - object_b.y, object_a.x - object_b.x);
        double normal = angle + pi;
        if (!object_a.destroyed) {
          object_b.direction = reflection(object_b.direction, normal);
        }
        if (!object_b.destroyed) {
          object_a.direction = reflection(object_a.direction, normal);
        }
      }
    }
  }

  void start() {
    running = true;
  }

  void stop() {
    running = false;
    spawnRate = minSpawnRate;
  }

  double reflection(direction, normal) {
    double dx = cos(direction);
    double dy = sin(direction);
    double nx = cos(normal);
    double ny = sin(normal);
    double rx = dx - 2 * dx * pow(nx, 2);
    double ry = dy - 2 * dy * pow(ny, 2);
    return atan2(ry, rx);
  }

  bool offScreen(Asteroid object) {
    double distFromCenter = sqrt(pow(sizeWidth / 2 - object.x, 2) + pow(sizeHeight / 2 - object.y, 2));
    if (distFromCenter > boundRadius) {
      return true;
    }
    return false;
  }
}
