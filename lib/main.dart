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
          print(state);
          if(state is Uninitialized){
            return SplashScreen();
          }else if(state is Authenticated){
            return Home(userName: state.displayName, userImage: state.urlImage);
          }else if(state is Unauthenticated){
            return LoginScreen(userRepository: _userRepository);
          }
          return Container();
        },)
    );
  }
}