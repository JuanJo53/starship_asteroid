import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_event.dart';
import 'package:starshipasteroid/bloc/login_bloc/bloc.dart';
import 'package:starshipasteroid/repository/userRepository.dart';
import 'package:starshipasteroid/ui/googleLogInButton.dart';

class LoginOptions extends StatefulWidget {
  //Inicializamos el repositorio para el usuario, usando patron BLOC
  final UserRepository _userRepository;
  //Constructor de esta pagina, que recive un userRepository.
  LoginOptions({Key key,@required UserRepository userRepository}) 
  :assert(userRepository!=null),
  _userRepository=userRepository,
  super(key: key);

  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  LoginBloc _loginBloc;//Declaramos un objeto LoginBloc
  UserRepository get _userRepository=>widget._userRepository;//Instanciamos nuestro userRepository como widget.

  @override
  void initState() {
    super.initState();
    //Instanciamos el loginBloc como un BlocProvider que nos dara los estados y eventos del Login.
    _loginBloc=BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    //Retornamos un BlocListener que controla y escucha los estados del Login.
    return BlocListener<LoginBloc,LoginState>(
      listener: (context,state){
        //Si el estado es fallido, muestra un Snackbar con un Mensaje de Error.
        if(state.isFailure){
          Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                children: <Widget>[
                  Text('Login Failed'),
                  Icon(Icons.error),
                ],
              ),
              backgroundColor: Colors.red,
            )
          );
        }
        //Si el estado del Login es con exito, cambia al estado de la Autenticacion como LoggedIn
        if(state.isSuccess){
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      //BlocBuilder que nos permita mostrar elementos de flutter normal.
      child: BlocBuilder<LoginBloc,LoginState>(
        builder: (context,state){
          return Center(
            child: GoogleLogInGoogle(),//Boton de Inicio de Sesion con Google
          );
        }
      ),
    );
  }
}