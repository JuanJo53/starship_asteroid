import 'package:flutter/cupertino.dart';

class LoginState {
  final bool isSuccess;
  final bool isFailure;

  LoginState({@required this.isSuccess,@required this.isFailure});

  factory LoginState.empty(){
    return LoginState(
      isSuccess: false,
      isFailure: false,
    );  
  }

  factory LoginState.loading(){
    return LoginState(isSuccess: false, isFailure: false);
  }
  factory LoginState.failure(){
    return LoginState(isSuccess: false, isFailure: true);
  }
  factory LoginState.success(){
    return LoginState(isSuccess: true, isFailure: false);
  }

  LoginState copyWith({
    bool isSuccess,
    bool isFailure,
  }){
    return LoginState(isSuccess: isSuccess??this.isSuccess, isFailure: isFailure??this.isFailure);
  }

  @override
  String toString() {
    return '''LoginState{
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }

}