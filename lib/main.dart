import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
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
}