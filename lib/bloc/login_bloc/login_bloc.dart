import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:starshipasteroid/repository/userRepository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;//Parametro del repositorio para el usuario.
  //Constructor con el parametro de userRepository que es requerido y debe ser diferente de null.
  LoginBloc({@required UserRepository userRepository})
  :assert(userRepository!=null),
  _userRepository=userRepository;
  //Indicamos el estado inicial del login en empty, es decir, que no hubo aun interaccion con el loggin y el usuario.
  @override
  LoginState get initialState => LoginState.empty();
  //Obtenemos todos los eventos del login, que en este caso solo es uno.
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    //Si el evento es cuando presiona el boton para iniciar sesion con google.
    if(event is LoginWithGooglePressed){
      //Llama a la funcion para cambiarle el estado, previamente usando funcion del repositorio para iniciar sesion con google.  
      yield* _mapLogInWithGooglePressedToState();
    }
  }
  //Stream que inicia sesion con google y cambia el estado del loggin a "success".
  Stream<LoginState> _mapLogInWithGooglePressedToState()async*{
    try{
      await _userRepository.signInWithGoogle();//Iniciamos sesion con google
      yield LoginState.success();//Cambiamos el estado a success
    }catch(_){
      yield LoginState.failure();//Cambiamos el estado a failure
    }
  }
}