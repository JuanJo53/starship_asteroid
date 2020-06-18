import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starshipasteroid/rankView.dart';

import 'gameController.dart';
import 'newGame.dart';

import 'package:audioplayers/audioplayers.dart';
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
  AudioPlayer menuAudio;
  bool playingMenuAudio=false;
  IconData musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');
  GoogleSignIn googleSignIn=GoogleSignIn(scopes: ['email']);
  @override
  void initState() {    
    Flame.audio.loadAll([
    'Space_Game_Loop.mp3',]);
    super.initState();
    // googleSignIn.signIn();
    // googleSignIn.currentUser.id;
    // googleSignIn.currentUser.displayName;
    gameController = GameController();
    startMnuAudio();    
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
                  splashColor: Colors.lightBlue,
                  color: Colors.black,
                  child: new Text("Jugar",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                  onPressed: ()async{
                    gameController.newGame=true;
                    menuAudio.stop();
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>NewGame()));
                  },
                ),
                new RaisedButton(
                  splashColor: Colors.lightBlue,
                  color: Colors.black,
                  child: new Text("Rank",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                  onPressed: ()async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>RankView()));
                  },
                ),
              ],
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          setState(() {
            if (playingMenuAudio) {          
              musicIcon=IconData(0xe04f, fontFamily: 'MaterialIcons');
              menuAudio.pause();
              playingMenuAudio=false;
            } else{         
              musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');     
              menuAudio.resume();
              playingMenuAudio=true;
            }
          });
        },        
        child: Icon(
          musicIcon,
          size: 20,
        ),
      ),
    );
  }
  void startMnuAudio() async {
    playingMenuAudio=true;
    menuAudio = await Flame.audio.loopLongAudio('Space_Game_Loop.mp3', volume: .25);
  }
}