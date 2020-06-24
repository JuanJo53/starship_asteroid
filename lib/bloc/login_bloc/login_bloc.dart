import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:starshipasteroid/repository/userRepository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
  :assert(userRepository!=null),
  _userRepository=userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is LoginWithGooglePressed){
      yield* _mapLogInWithGooglePressedToState();
    }
  }

  Stream<LoginState> _mapLogInWithGooglePressedToState()async*{
    try{
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    }catch(_){
      yield LoginState.failure();
    }
  }
}