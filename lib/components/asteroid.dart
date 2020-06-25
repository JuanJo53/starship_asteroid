import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:starshipasteroid/gameController.dart';
class Asteroid {
  List<double> randVertices;//Lista de 
  Paint boxPaint;//Figura donde se dibujara al asteroide
  double x;//Posicion en el eje x
  double y;//Posicion en el eje y
  double size;//Tamaño del asteroide expresado en un numero
  double minSize;//Tamaño minimo que se puede generar
  double maxSize;//Tamaño maximo que se puede generar
  double direction;//Direccion hacia la que va el asteroide
  double angle;//Angulo para la rotacion del asteroide
  double rotationSpeed;//Velocidad de rotacion del asteroide
  double maxRotationSpeed;//Velocidad maxima de rotacion del asteroide que se puede generar
  double speed;//Velocidad de desplazamiento del asteroide
  double minSpeed;//Velocidad minima de desplazamiento del asteroide
  double maxSpeed;//Velocidad maxima de desplazamiento del asteroide
  double numVertices;//Numero de vertices que tendra el asteroide al momento de dibujarlo
  double noiseMulti;//Ruido para dibujar las lineas que unen los vertices del asteroide
  bool destroyed; //Si el asteroide esta destruido o no
  AudioPlayer expAudio;//Para el sonido de explocion cuando se destruye  
  GameController gameController;

  Asteroid(double init_x, double init_y, double init_direction) {
    //Estos datos se nos pasa cuando se crea el asteroide desde la clase "Asteroids"
    x = init_x;
    y = init_y;
    direction = init_direction;

    minSize = 10;
    maxSize = 40;
    randVertices = List<double>();
    maxRotationSpeed = 0.04;
    minSpeed = 1;
    maxSpeed = 4;
    numVertices = 20;
    noiseMulti = 2;
    destroyed = false;

    Random rand = Random();//Declaramos nuestro random para generar los numeros randomicos que necesitamos.

    //Dependiendo del numero de vertices definido, se agregan numeros randomicos para determinar las vertices del asteroide
    for (int i = 0; i < numVertices; i++) {
      //Agregamos a la lista el numero generado tomando en cuenta el ruido.
      randVertices.add(rand.nextDouble() * noiseMulti * 2 - noiseMulti);
    }

    size = rand.nextDouble() * (maxSize - minSize) + minSize;//Genera tamaño randomico para el asteroide
    angle = rand.nextDouble() * pi * 2;//Genera angulo randomico para el asteroide
    rotationSpeed = rand.nextDouble() * maxRotationSpeed * 2 - maxRotationSpeed;//Generauna velocidad de rotacion randomica para el asteroide
    speed = rand.nextDouble() * (maxSpeed - minSpeed) + minSpeed;//Genera una velocidad de desplazamiento randomica para el astroide
  }

  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x + size * cos(angle), y + size * sin(angle));//Posicion inicial para dibujar el asteroide
    //Dependiendo del numero de vertices generadas, se dibujara una linea uniendolas de forma circular.
    for (int vert = 0; vert < randVertices.length; vert ++) {
      double randVertice = randVertices[vert];
      double theta = pi * 2 / numVertices * vert;
      path.lineTo(x + (size + randVertice) * cos(theta + angle), y + (size + randVertice) * sin(theta + angle));//Dibuja linea hacia la siguiente vertice
    }

    path.lineTo(x + size * cos(angle), y + size * sin(angle));//Ultimna linea que se une a la posicion incial

    boxPaint = Paint();
    boxPaint.color = Colors.amber;
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    canvas.drawPath(path, boxPaint);//Dibujamos con canvas, pasandole el Path y su BoxPaint del asteroide.
  }

  @override
  void update(double t) {
    x += cos(direction) * speed;//Desplazamiento en el eje x dependiendo su velocidad y direccion
    y += sin(direction) * speed;//Desplazamiento en el eje y dependiendo su velocidad y direccion
    angle += rotationSpeed;//Cambio de angulo para la rotacion dependiento su velocidad de rotacion    
  }
  //Funcion que verifica si el asteroide choco con algo
  bool hit(double strength) {
    size -= strength * 4;//Se le reduce el tamaño al asteroide dependiendo la fuerza que se mande
    
    //Si el tamaño reduce hasta menos del tamaño minimo, es destruido
    if (size < minSize) {
      destroy();      
      return true;
    }
    return false;
  }
  //Esta funcion se llama cuando se quiere destruir al asteroide y ya no mostrarlo
  bool destroy() {
    soundExplotion();//Suena SFX de explosion
    destroyed = true;
    return destroyed;
  }
  //Esta funcion reproduce el sonido de explocion de assets/audio/
  void soundExplotion() async{
    expAudio = await Flame.audio.play('explosion_SFX.mp3', volume: .25);
  }
}
