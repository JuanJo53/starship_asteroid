import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authenticacion_state.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_event.dart';
import 'package:starshipasteroid/bloc/simple_bloc_delegate.dart';
import 'package:starshipasteroid/repository/userRepository.dart';
import 'package:starshipasteroid/ui/home.dart';
import 'package:starshipasteroid/ui/login_screen.dart';
import 'package:starshipasteroid/ui/splash_screen.dart';
void main() {
  //Se inicializa el Binding de los widgets para que no hallan problemas al user Flame.
  WidgetsFlutterBinding.ensureInitialized();
  //Se inicializa un BlocSupervisor para monitorear los eventos, transiciones y errores al usar BLOC.
  BlocSupervisor.delegate=SimpleBlocDelegate();
  // Creamos nuestro userRepository donde tenemos todas las funciones que interactuan con Firebase.
  final UserRepository userRepository=UserRepository();
  //Iniciamos la aplicacion con BLOC en estado de AppStarted.
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
  //Constructor con el atributo de nuestro userRepository, que si o si debe existir.
  App({Key key,@required UserRepository userRepository})
  :assert(userRepository!=null),
  _userRepository=userRepository,
  super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Este BlocBuilder nos dejara implementar componentes de flutter pero verificando estados de BLOC
      home: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        builder: (context,state){
          if(state is Uninitialized){
            return SplashScreen();//Si la aplicacion no inicio muestra nuestro splashScreen.
          }else if(state is Authenticated){
            //Si existe una autenticacion, mostrara nuestro Home.
            return Home(userName: state.displayName, userImage: state.urlImage);
          }else if(state is Unauthenticated){
            //Si no existe una autenticacion, pero la app ya inició, mostrara la pantalla de Login
            return LoginScreen(userRepository: _userRepository);
          }
          return Container();
        },)
    );
  }
}