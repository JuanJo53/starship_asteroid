import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starshipasteroid/bloc/login_bloc/login_bloc.dart';
import 'package:starshipasteroid/repository/userRepository.dart';
import 'package:starshipasteroid/ui/login_options.dart';
class LoginScreen extends StatelessWidget {
  //Inicializamos el repositorio para el usuario, usando patron BLOC
  final UserRepository _userRepository;

  //Constructor de esta pagina, que recive un userRepository.
  LoginScreen({Key key,@required UserRepository userRepository })
  :assert(userRepository!=null),
  _userRepository=userRepository,
  super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Login With a Google Account!'),
      ),
      //En el body declaramos nuestro BlocProvider donde Controlaremos el LoginBloc con sus estados y eventos.
      body: BlocProvider<LoginBloc>(
        //Creamos el LoginBloc.
        create: (context)=>LoginBloc(userRepository: _userRepository),
        //Mostramos la pantalla donde se veran las opciones de Login (actualmente solo con Google).
        child: LoginOptions(userRepository: _userRepository),
      ),
      backgroundColor: Colors.black,
    );
  }
}