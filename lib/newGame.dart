import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:starshipasteroid/gameController.dart';
class NewGame extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<NewGame> {
  GameController gameController;//Declaramos nuestro GameController
  Util flameUtil = Util();//Declaramos el flameUtil para usar virtudes de Flame
  TapGestureRecognizer tapper = TapGestureRecognizer();//Nos permite detectar cuando se toca la pantalla.
  //Funcion donde se inicia el juego como tal, y 
  void Start()async{
    //Se inicializa el Binding de los widgets para que no hallan problemas al user Flame.
    WidgetsFlutterBinding.ensureInitialized();
    
    gameController = GameController();//Inicializamos el GameController

    //Definimos el tamaño de la pantalla y la orientacion del dispositivo como vertical.
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);

    //Inicializamos nuestro detector de toques en pantalla.
    tapper.onTapDown = gameController.onTapDown;
    flameUtil.addGestureRecognizer(tapper);    
  }
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: new Container( 
        child: new Stack(
          children: <Widget>[
            //Llamamos al gameController como widget si es que es diferente de null.
            gameController.widget!=null?gameController.widget:new Container(),
            new RawMaterialButton(//Boton de Pausa en parte superior izquierda
              onPressed: () {
              //Se pausea el juego y muestra las diferentes opciones que tenemos al pusar el juego.
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
                            //En este children tenemos todos los botones al pausear el juego.
                            children: <Widget>[
                              //Boton para continuar el juego
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Continue",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){                                                                  
                                  Navigator.pop(context);//Se cierra el alert Dialog
                                  gameController.paused=false;//El juego continua
                                },
                              ),
                              //Boton de Reiniciar el juego
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Restart",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){
                                  Navigator.pop(context);//Se cierra el alert dialog
                                  gameController.restartGame();//Reiniciamos todos los valores del juego.
                                  gameController.paused=false;//Se despausea el juego
                                },
                              ),
                              //Boton para volver al menu incial
                              OutlineButton(
                                splashColor: Colors.lightBlue,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.transparent,
                                child: new Text("Go to Menu",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                                onPressed: (){
                                  //TODO: Aqui hay un bug: inicia nuevo juego sobre el anterior, al volver al menu.
                                  flameUtil.removeGestureRecognizer(tapper);//Retiramos el detector de taps                                  
                                  gameController.paused=true;//Pausamos el juego
                                  gameController.endGame();//Terminamos el juego
                                  gameController=null;//Eliminamos el GameContoller
                                  Navigator.pop(context);//Se cierra el alert dialog
                                  Navigator.pop(context);//Vuelve al menu
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
  //InitState donde se llama a la funcion start debido a que esta tiene valores asincronos.
  void initState() {
    Start();
  }
}