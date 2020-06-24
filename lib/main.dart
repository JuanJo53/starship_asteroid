import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authenticacion_state.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_event.dart';
import 'package:starshipasteroid/bloc/simple_bloc_delegate.dart';
import 'package:starshipasteroid/rankView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starshipasteroid/repository/userRepository.dart';
import 'package:starshipasteroid/ui/home.dart';
import 'package:starshipasteroid/ui/login_screen.dart';
import 'package:starshipasteroid/ui/splash_screen.dart';
import 'gameController.dart';
import 'newGame.dart';

import 'package:audioplayers/audioplayers.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate=SimpleBlocDelegate();
  final UserRepository userRepository=UserRepository();

  runApp(
    BlocProvider(
      create: (context)=>AuthenticationBloc(userRepository:  userRepository)
      ..add(AppStarted()),
      child: App(userRepository: userRepository),
    )
    // MaterialApp(
    //   home: MyApp()
    // )
  );
}

class App extends StatelessWidget{
  final UserRepository _userRepository;
  App({Key key,@required UserRepository userRepository})
  :assert(userRepository!=null),
  _userRepository=userRepository,
  super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        builder: (context,state){
          if(state is Uninitialized){
             return SplashScreen();
          }
          if(state is Authenticated){
             return Home(userName: state.displayName, userImage: state.urlImage);
          }
          if(state is Unauthenticated){
             return LoginScreen(userRepository: _userRepository);
          }
          return Container();
        },)
    );
  }

}

// class MyApp extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return _MyApp();
//   }
// }
// class _MyApp extends State<MyApp> {
//   Size size;
//   GameController gameController;    
//   AudioPlayer menuAudio;
//   bool playingMenuAudio=false;
//   IconData musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');  
//   final GoogleSignIn googleSignIn= new GoogleSignIn();
//   final FirebaseAuth _auth=FirebaseAuth.instance;
//   String userImage;
//   String userName;

//   @override
//   void initState() {    
//     Flame.audio.loadAll([
//     'Space_Game_Loop.mp3',]);
//     super.initState();
//     // signOut();
//     auth();  
//     if(googleSignIn.currentUser!=null){
//       if(googleSignIn.currentUser.photoUrl!=''){
//         userImage=googleSignIn.currentUser.photoUrl;
//         userName=googleSignIn.currentUser.displayName;
//       }else{
//         userImage='';
//       }
//     }
//     gameController = GameController();
//     startMnuAudio();    
//   }
//   @override
//   Widget build(BuildContext context) {
//     size=MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           new Container(
//             decoration: BoxDecoration(  
//               image: DecorationImage(
//                 image: AssetImage('assets/images/background.jpg'), 
//                 fit: BoxFit.cover)
//             ),  
//             child: new Center(
//                 child: new Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     new Image.asset('assets/images/titulo1.png',fit: BoxFit.cover,), 
//                     new RaisedButton(
//                       splashColor: Colors.lightBlue,
//                       color: Colors.black,
//                       child: new Text("Play",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
//                       onPressed: ()async{
//                         gameController.newGame=true;
//                         menuAudio.stop();
//                         await Navigator.push(context, MaterialPageRoute(builder: (context)=>new NewGame()));
//                       },
//                     ),
//                     new RaisedButton(
//                       splashColor: Colors.lightBlue,
//                       color: Colors.black,
//                       child: new Text("Rank",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
//                       onPressed: ()async{
//                         await Navigator.push(context, MaterialPageRoute(builder: (context)=>RankView()));
//                       },
//                     ),
//                     new RaisedButton(
//                       splashColor: Colors.lightBlue,
//                       color: Colors.black,
//                       child: new Text("Change Account",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
//                       onPressed: ()async{
//                         await signOut();
//                         await auth();
//                         setState(() {
//                           if(googleSignIn.currentUser!=null){
//                             if(googleSignIn.currentUser.photoUrl!=''){
//                               userImage=googleSignIn.currentUser.photoUrl;
//                               userName=googleSignIn.currentUser.displayName;
//                             }
//                           }
//                         });
//                       },
//                     ),
//                     new RaisedButton(
//                       splashColor: Colors.lightBlue,
//                       color: Colors.black,
//                       child: new Text("Quit Game",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
//                       onPressed: ()async{
//                         await signOut();
//                         dispose();
//                         SystemNavigator.pop();
//                       },
//                     ),
//                   ],
//                 ),
//             ),
//           ), 
//           Container(
//             child: Row(
//               children: <Widget>[
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(90),                  
//                   child: Image(
//                     width: size.width/8,
//                     image: NetworkImage(userImage!=null?userImage:''),
//                   ),
//                 ),
//                 Text(userName!=null?userName:'',style: TextStyle(color: Colors.lightGreenAccent),),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         onPressed: () {
//           setState(() {
//             if (playingMenuAudio) {          
//               musicIcon=IconData(0xe04f, fontFamily: 'MaterialIcons');
//               menuAudio.pause();
//               playingMenuAudio=false;
//             }else{         
//               musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');     
//               menuAudio.resume();
//               playingMenuAudio=true;
//             }
//           });
//         },        
//         child: Icon(
//           musicIcon,
//           size: 20,
//         ),
//       ),
//     );
//   }
//   void startMnuAudio() async {
//     playingMenuAudio=true;
//     menuAudio = await Flame.audio.loopLongAudio('Space_Game_Loop.mp3', volume: .25);
//   }
//   Future<bool> isLoggedIn()async{
//     FirebaseUser user=await FirebaseAuth.instance.currentUser();
//     if(user!=null){
//       return true;
//     }else{
//       return false;
//     }
//   }
//   void auth()async{
//     try{
//       FirebaseUser user=await FirebaseAuth.instance.currentUser();
//       if(user==null){      
//         GoogleSignInAccount acount=await googleSignIn.signIn();
//         GoogleSignInAuthentication Gauth=await acount.authentication.catchError((e){print("Cancelado");});
//         final AuthCredential credential = GoogleAuthProvider.getCredential(
//           accessToken: Gauth.accessToken,
//           idToken: Gauth.idToken,
//         );
//         AuthResult auth= await _auth.signInWithCredential(credential);   
//         if(Firestore.instance.collection('usuarios').document(auth.user.uid).documentID==''){
//           Firestore.instance.collection('usuarios').document(auth.user.uid).setData(
//             {
//               'nombre': googleSignIn.currentUser.displayName,
//               'score': 0,
//               'playTime': DateTime.now(),
//             }
//           );
//         }  
//       }
//     }catch(e){
//       print('Error al hacer el auth.\n'+e);
//     }
//   }
//   void signOut()async{
//     print('signedOut');
//     await FirebaseAuth.instance.signOut();
//     await googleSignIn.signOut();
//   }
// }