import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class GameOver{
  final GameController gameController;//De aqui obtendremos el puntaje al morir del jugador.
  TextPainter painter;
  Offset posicion;

  GameOver(this.gameController){
    painter = TextPainter(
      textAlign: TextAlign.center,//Especifica que el texto sea centreado
      textDirection: TextDirection.ltr,//Especifica que se escriba de izquierda a derecha
    ); 
    posicion = Offset.zero;//Su pocicion inicial
  }
  //Renderizamos aqui el dibujo de la pantalla de Game Over.
  void render(Canvas canvas){
    painter.paint(canvas, posicion);
  }
  //Al morir, se actualiza y muestra el puntaje del jugador, ademas de su puntaje mas alto.
  void update(double t){
    //Si el texto de nuestro painter no es vacio y ademas es diferente al puntaje que tenia al morir, dibuja el texto de game over.
    if((painter.text??'')!=gameController.score.toString()){
      //Si el puntaje del juego en el que acaba de morir es mayor a su maximo puntaje hasta el momento del jugador.
      if(gameController.score>gameController.currentHighscore){
        //Dibujamos el mismo texto en el puntaje actual y el mas alto.
        painter.text=TextSpan(
          text: 'GAME OVER\nScore: '+gameController.score.toString()+'\nYour HighScrore: '+gameController.score.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          )
        );
      }else{
        //De no superar su mayor puntaje, solo muestra su puntaje actual y su mayor puntaje actual del jugador.
        painter.text=TextSpan(
          text: 'Score: '+gameController.score.toString()+'\nYour HighScrore: '+gameController.currentHighscore.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          )
        );
      }
      painter.layout();
      posicion=Offset(
        (gameController.screenSize.width/2)-(painter.width/2),//Horizontalmente al centro
        (gameController.screenSize.height*0.5)-(painter.height/2),//Verticalmente al centro
      );      
    }  
  }
}