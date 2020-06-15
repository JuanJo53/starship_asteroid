import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:starshipasteroid/gameController.dart';
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
    Flame.audio.loadAll([
    'Space_Game_Loop.mp3',]);
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
        decoration: BoxDecoration(  
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), 
            fit: BoxFit.cover)
        ),  
        child: new Stack(
          children: <Widget>[
            Center(
              child: new Image(
                width: MediaQuery.of(context).size.width/3,
                height: MediaQuery.of(context).size.height/3,
                image: AssetImage('assets/images/rocket1.gif',), 
              ),
            ),
            gameController.widget!=null?gameController.widget:Container(),
            new RawMaterialButton(
              onPressed: () {
                gameController.pausado=true;
                print('pause');
                showDialog(context: context, 
                  builder: (context){
                    return Theme(
                      data: Theme.of(context).copyWith(dialogBackgroundColor:Colors.black12),    
                      child: new AlertDialog(                      
                        title: Center(child: Text("Juego Pausado!",style: TextStyle(color: Colors.lightGreenAccent)),),
                        content: Column(                        
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Continuar",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){                                
                                  Navigator.pop(context);
                                  gameController.pausado=false;
                                },
                              ),
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Reiniciar",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){
                                  Navigator.pop(context);
                                  gameController.restartGame();
                                  gameController.pausado=false;
                                },
                              ),
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Salir a Menu",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){
                                  //TODO: Aqui hay un bug, no inicia nuevo juego, al volver al menu.
                                  gameController.nuevoJuego=false;
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