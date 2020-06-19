import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:starshipasteroid/gameController.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:starshipasteroid/main.dart';

class NewGame extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<NewGame> {
  GameController gameController;
  void Start()async{    
    Flame.images.loadAll(<String>[
      'rocket1.gif',
      'rocket_frame_0.png',
      'rocket_frame_1.png',
      'rocket_frame_2.png',
      'rocket_frame_3.png',
      'rocket_frame_4.png',
      'rocket_frame_5.png',
      'rocket_frame_6.png',
    ]);
    WidgetsFlutterBinding.ensureInitialized();
    Util flameUtil = Util();

    gameController = GameController();

    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);
    
    TapGestureRecognizer tapper = TapGestureRecognizer();
    tapper.onTapDown = gameController.onTapDown;
    flameUtil.addGestureRecognizer(tapper);
    
  }
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: new Container( 
        child: new Stack(
          children: <Widget>[
            gameController.widget!=null?gameController.widget:Container(),
            new RawMaterialButton(
              onPressed: () {
                gameController.paused=true;
                print('pause');
                showDialog(context: context, 
                  builder: (context){
                    return Theme(
                      data: Theme.of(context).copyWith(dialogBackgroundColor:Colors.black12),    
                      child: new AlertDialog(                      
                        title: Center(child: Text("Game Paused!",style: TextStyle(color: Colors.lightGreenAccent)),),
                        content: Column(                        
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Continue",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){                                
                                  Navigator.pop(context);
                                  gameController.paused=false;
                                },
                              ),
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Restart",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){
                                  Navigator.pop(context);
                                  gameController.restartGame();
                                  gameController.paused=false;
                                },
                              ),
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Go to Menu",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){
                                  //TODO: Aqui hay un bug, no inicia nuevo juego, al volver al menu.
                                  // gameController.nuevoJuego=false;
                                  gameController.endGame();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                        ),
                      )
                    );
                  },
                );
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.pause,
                size: 30.0,
              ),
              padding: EdgeInsets.all(12.0),
              shape: CircleBorder(),
            ),
          ],
        ),
    ));
  }
  void initState() {
    Start();
  }
}