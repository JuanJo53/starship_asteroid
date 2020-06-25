import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:starshipasteroid/repository/userRepository.dart';

import 'authenticacion_state.dart';
import 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;//Parametro del repositorio para el usuario.
  //Constructor con el parametro de userRepository que es requerido y debe ser diferente de null.
  AuthenticationBloc({@required UserRepository userRepository})
  :assert(userRepository!=null),
  _userRepository = userRepository;
  //Indicamos el estado inicial de la autenticacion en no inicializado, es decir, que la aplicacion se esta iniciando.
  @override  
  AuthenticationState get initialState => Uninitialized();
  //Obtenemos todos los eventos de la autenticacion, que en este caso son tres.
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    //Si el evento es cuando la aplicacion esta iniciando.
    if(event is AppStarted){
      yield* _mapAppStartedToState();
    }
    //Si el evento es cuando el usuario desea autenticarse en la aplicacion.
    if(event is LoggedIn){
      yield* _mapLoggedInToState();
    }
    //Si el evento es cuando el usuario desea desloggearse de la aplicacion
    if(event is LoggedOut){
      yield* _mapLoggedOutToState();
    }    
  }
  //Stream que le pasa los datos del inicio de sesion con firebase y cambia el estado dependiendo el resultado del signIn.
  Stream<AuthenticationState> _mapAppStartedToState()async*{
    try{
      final isSignedIn= await _userRepository.isSignedIn();
      if(isSignedIn){
        //Si existe un usaurio autenticado cambia el estado a autenticado.
        final user = await _userRepository.getUser();
        final image = await _userRepository.getUserImage();
        yield Authenticated(user,image);
      }else{
        //Si no existe un usuario autenticado, el estado cambia a no autenticado.
        yield Unauthenticated();
      }
    }catch(_){
      //Si hubo algun error, el estado cambia a no autenticado.
      yield Unauthenticated();
    }
  }
  //Stream que cambia el estado a loggeado en la aplicacion.
  Stream<AuthenticationState> _mapLoggedInToState()async*{
    try{
      //Obtenemos el nombre del usuario autenticado y el url de su foto de perfil, y lo apsamos al estado de autenticado.
      yield Authenticated(await _userRepository.getUser(),await _userRepository.getUserImage());
    }catch(_){
      //Si hubo algun error, el estado cambia a no autenticado.
      yield Unauthenticated();
    }
  }
  //Stream que cambia el estado a desloggeado en la aplicacion.
  Stream<AuthenticationState> _mapLoggedOutToState()async*{
    yield Unauthenticated();//Cambiamos el estado a no autenticado
    _userRepository.signOut();//Realizamos el signOut de firebase y google desde el reposirotio del usuario.
  }
}