import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starshipasteroid/rankView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final GoogleSignIn googleSignIn= new GoogleSignIn();
  final FirebaseAuth _auth=FirebaseAuth.instance;

  @override
  void initState() {    
    Flame.audio.loadAll([
    'Space_Game_Loop.mp3',]);
    super.initState();
    auth();    
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
                new RaisedButton(
                  splashColor: Colors.lightBlue,
                  color: Colors.black,
                  child: new Text("Cambiar Cuenta",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                  onPressed: ()async{
                    await signOut();
                    await auth();
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
  Future<bool> isLoggedIn()async{
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(user!=null){
      return true;
    }else{
      return false;
    }
  }
  void auth()async{
    try{
      FirebaseUser user=await FirebaseAuth.instance.currentUser();
      if(user==null){      
        GoogleSignInAccount acount=await googleSignIn.signIn();
        GoogleSignInAuthentication Gauth=await acount.authentication.catchError((e){print("Cancelado");});
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: Gauth.accessToken,
          idToken: Gauth.idToken,
        );
        AuthResult auth= await _auth.signInWithCredential(credential);      
        Firestore.instance.collection('usuarios').document(auth.user.uid).setData(
          {
            'nombre': googleSignIn.currentUser.displayName,
            'score': 0,
            'playTime': DateTime.now(),
          }
        );
      }
    }catch(e){
      print('Error al hacer el auth.\n'+e);
    }
  }
  void signOut()async{
    print('signedout');
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }
}