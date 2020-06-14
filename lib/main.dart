import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:starshipasteroid/gameController.dart';

import 'newGame.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp()
    )
  );
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }

}

class _MyApp extends State<MyApp> {
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
        child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('assets/images/titulo1.png',fit: BoxFit.cover,), 
                new RaisedButton(
                splashColor: Colors.pinkAccent,
                color: Colors.black,
                child: new Text("Jugar",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>NewGame()));},
              ),
              ],
            ),
        ),
      )
      );
  }
  void initState() {
    Start();
  }
}