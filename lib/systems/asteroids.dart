import 'dart:math';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/components/asteroid.dart';

class Asteroids {
  List<Asteroid> asteroids;//Lista de objetos Asteroid, de la clase "Asteroid"
  double spawnRadius;//Donde los asteroides aparecen 
  double boundRadius;//Donde los asteroides son destruidos 
  double directionNoise;//Que tanto los asteroides se alejan del centro 
  double spawnRate;//Cuan rapido los asteroides aparecen
  double minSpawnRate;//Minimo de rapidez entre que aparece un asteroide
  double maxSpawnRate;//Maximo de rapidez entre que aparece un asteroide
  double spawnGrowthRate;//Incremento de la rapidez en la que aparecen
  double sizeWidth;//Ancho
  double sizeHeight;//Alto
  bool running;//Booleano que representa cuando los asteroides estan apareciendo o no

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
  //Se renderiza cada asteroide en la lista de asteroides
  @override
  void render(Canvas canvas) {
    asteroids.forEach((Asteroid asteroid) => asteroid.render(canvas));
  }
  //Algun cambio de estado o posicion de los asteroides
  @override
  void update(double t) {
    Random rand = Random();

    if (rand.nextDouble() < spawnRate) {
      double location = rand.nextDouble() * pi * 2;//Generamos punto de aparicion del asteroide
      double x = sizeWidth / 2 + cos(location) * spawnRadius;//Posicion en eje x respecto del punto de aparicion
      double y = sizeHeight / 2 + sin(location) * spawnRadius;//Posicion en eje y respecto del punto de aparicion

      //Generamos direccion randomica del asteroide
      double direction = atan2(sizeHeight / 2 - y, sizeWidth / 2 - x) + rand.nextDouble() * directionNoise * 2 - directionNoise;
      Asteroid asteroid = new Asteroid(x, y, direction);//Creamos nuevo asteroide con datos generados
      asteroids.add(asteroid);//Agregamos el asteroide a la lista de asteroides
    }

    //Si los asteroides estan apareciendo (running), es decir, que no esta en pausa o el juego no termino
    if (running && spawnRate < maxSpawnRate) {
      spawnRate += spawnGrowthRate;//El tiempo en el que aparecenlosa steroides va incrementando
    }

    asteroids.forEach((Asteroid asteroid) => asteroid.update(t));//Se hace el update de cada asteroide
    asteroids.removeWhere((Asteroid asteroid) => this.offScreen(asteroid) || asteroid.destroyed);//Se elimina de la lista cualquier asteroide que salio de la pantalla o esta destruido
    
    //Aqui se verifica si los asteroides chocaron con algun otro asteroide, se verifica con cada astroide creado
    asteroids.forEach((Asteroid asteroid) => this.hasCollidedWithMany(asteroid, asteroids));
  }
  //Reiniciar los asteroides
  void resetAsteroids(){
    asteroids.clear();//Elimina todos los elementos en la lsita de asteroides
  }
  //Esta funcion hace que se verifique a un asteroide con todos los asteroides creados, llamando a la funcion donde se verifica si hubo colision
  void hasCollidedWithMany(Asteroid object_a, List<Asteroid> objects) {
    objects.forEach((Asteroid object_b) => this.hasCollided(object_a, object_b));
  }
  //Controla si hubo colision entre algun asteroide con otro asteroide
  void hasCollided(Asteroid object_a, Asteroid object_b) {
    //La suma de sus tamaños en el limite de distancia entre ambos para que signifique colision
    double distToHit = object_a.size + object_b.size;
    //Si la distancia limite para que signifique colision es mayor a la diferencia de sus posiciones
    if (object_a.x - object_b.x < distToHit && object_a.y - object_b.y < distToHit) {
      //Calcula la distancia entre el asteroide "a" y el asteroide "b"
      double distBetween = sqrt(pow(object_a.x - object_b.x, 2) + pow(object_a.y - object_b.y, 2));
      //Si la distancia entre ambos es menor al limite de distancia ente ambos para que signifique colision
      if (object_a != object_b && distBetween < distToHit) {
        object_a.hit(0.5);//Le aplicamos daño al asteroide "a", reduciendo su tamaño
        object_b.hit(0.5);//Le aplicamos daño al asteroide "b", reduciendo su tamaño
        
        //Nuevo dependiento en las posiciones de los dos asteroides
        double angle = atan2(object_a.y - object_b.y, object_a.x - object_b.x);
        //Valor normal ayuda a cambiar la direccion cuando chocan
        double normal = angle + pi;
        //Si en la colision no se destruyo el asteroide "a"
        if (!object_a.destroyed) {
          //Existe un cambio en la direccion del asteroide "b"
          object_b.direction = reflection(object_b.direction, normal);
        }
        //Si en la colision no se destruyo el asteroide "b"
        if (!object_b.destroyed) {
          //Existe un cambio en la direccion del asteroide "a"
          object_a.direction = reflection(object_a.direction, normal);
        }
      }
    }
  }
  //Hace que los asteroides empiecen a aparecer
  void start() {
    running = true;
  }
  //Hace que los asteroides dejen de aparecer
  void stop() {
    running = false;
    spawnRate = minSpawnRate;
  }
  //Cambio de direccion del asteroide cuando chocan entre si
  double reflection(direction, normal) {
    double dx = cos(direction);
    double dy = sin(direction);
    double nx = cos(normal);
    double ny = sin(normal);
    double rx = dx - 2 * dx * pow(nx, 2);
    double ry = dy - 2 * dy * pow(ny, 2);
    return atan2(ry, rx);
  }
  //Devuelve como booleano si el asteroide salio de la pantalla o no
  bool offScreen(Asteroid object) {
    //Calcula la distancia entre los bordes de pantalla y el asteroide
    double distFromCenter = sqrt(pow(sizeWidth / 2 - object.x, 2) + pow(sizeHeight / 2 - object.y, 2));
    if (distFromCenter > boundRadius) {
      return true;
    }
    return false;
  }
}
