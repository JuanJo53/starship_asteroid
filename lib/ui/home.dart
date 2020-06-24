import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_event.dart';
import '../gameController.dart';
import '../newGame.dart';
import '../rankView.dart';

class Home extends StatelessWidget {
  final String userName;
  final String userImage;
  
  Size size;
  GameController gameController;    
  AudioPlayer menuAudio;
  bool playingMenuAudio=false;
  IconData musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');  

  Home({Key key, @required this.userName,@required this.userImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
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
                      child: new Text("Play",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                      onPressed: ()async{
                        // gameController.newGame=true;
                        // menuAudio.stop();
                        await Navigator.push(context, MaterialPageRoute(builder: (context)=>new NewGame()));
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
                      child: new Text("Change Account",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                      onPressed: ()async{
                        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                        // await auth();
                        // setState(() {
                        //   if(googleSignIn.currentUser!=null){
                        //     if(googleSignIn.currentUser.photoUrl!=''){
                        //       userImage=googleSignIn.currentUser.photoUrl;
                        //       userName=googleSignIn.currentUser.displayName;
                        //     }
                        //   }
                        // });
                      },
                    ),
                    new RaisedButton(
                      splashColor: Colors.lightBlue,
                      color: Colors.black,
                      child: new Text("Quit Game",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                      onPressed: ()async{
                        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                        SystemNavigator.pop();
                      },
                    ),
                  ],
                ),
            ),
          ), 
          Container(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),                  
                  child: Image(
                    width: size.width/8,
                    image: NetworkImage(userImage!=null?userImage:''),
                  ),
                ),
                Text(userName,style: TextStyle(color: Colors.lightGreenAccent),),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // setState(() {
          //   if (playingMenuAudio) {          
          //     musicIcon=IconData(0xe04f, fontFamily: 'MaterialIcons');
          //     menuAudio.pause();
          //     playingMenuAudio=false;
          //   }else{         
          //     musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');     
          //     menuAudio.resume();
          //     playingMenuAudio=true;
          //   }
          // });
        },        
        child: Icon(
          musicIcon,
          size: 20,
        ),
      ),
    );
  }
}