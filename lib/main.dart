import 'package:flame/util.dart';
import 'package:flutter/material.dart';

import 'gameController.dart';
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
    return _MyApp();
  }
}
class _MyApp extends State<MyApp> {
  GameController gameController;
  @override
  void initState() {
    super.initState();
    gameController = GameController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        decoration: BoxDecoration(
          color: Colors.red,      
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
                  splashColor: Colors.lightBlue,
                  color: Colors.black,
                  child: new Text("Jugar",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                  onPressed: ()async{
                    gameController.pausado=false;
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>NewGame()));
                  },
                ),
              ],
            ),
        ),
      )
    );
  }
}