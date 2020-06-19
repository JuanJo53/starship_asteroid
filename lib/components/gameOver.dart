import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starshipasteroid/gameController.dart';

class GameOver{
  final GameController gameController;
  TextPainter painter;
  TextPainter painterHS;
  Offset posicion;
  Offset posicionHS;

  GameOver(this.gameController){
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    posicion = Offset.zero;

    // painterHS = TextPainter(
    //   textAlign: TextAlign.center,
    //   textDirection: TextDirection.ltr,
    // );
    // posicionHS = Offset.zero;
  }

  void render(Canvas canvas){
    painter.paint(canvas, posicion);
    // painterHS.paint(canvas, posicionHS);
  }

  void update(double t){
    if((painter.text??'')!=gameController.score.toString()){
      painter.text=TextSpan(
        text: 'Score: '+gameController.score.toString()+'\nYour HighScrore: '+gameController.currentHighscore.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        )
      );
      painter.layout();
      posicion=Offset(
        (gameController.screenSize.width/2)-(painter.width/2),
        (gameController.screenSize.height*0.5)-(painter.height/2),
      );      
    }
    // if((painterHS.text??'')!=gameController.currentHighscore.toString()){
    //   painterHS.text=TextSpan(
    //     text: 'Your Highscore: '+gameController.currentHighscore.toString(),
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 30.0,
    //     )
    //   );
    //   painterHS.layout();
    //   posicionHS=Offset(
    //     (gameController.screenSize.width/2)-(painter.width/2),
    //     (gameController.screenSize.height*0.6)-(painter.height/2),
    //   );
    // }    
  }
}