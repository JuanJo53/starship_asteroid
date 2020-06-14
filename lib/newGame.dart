import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:starshipasteroid/gameController.dart';
import 'package:starshipasteroid/main.dart';

class NewGame extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }
}

class _MyApp extends State<NewGame> {
  GameController gameController;
  void Start()async{
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