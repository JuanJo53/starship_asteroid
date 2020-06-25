import 'package:flutter/cupertino.dart';
/*En esta clase es donde se controlaran los cambios de estado del BLOC de login.
Aqui haremos referencia a los estados de exito al iniciar sesion y de fallo al iniciar sesion. */
class LoginState {
  final bool isSuccess;//Parametro de exito
  final bool isFailure;//Parametro de fallo
  //Constructor con los parametros indicados, ambos requeridos.
  LoginState({@required this.isSuccess,@required this.isFailure});
  //Por medio de un factory, declaramos el estado inicial en empty. Porque aun no hubo interaccion con el login.
  factory LoginState.empty(){
    //Retornamos los estados de la clase.
    return LoginState(
      isSuccess: false,
      isFailure: false,
    );  
  }
  //Declaramos el estado loading o cargando, donde los estados de exito y fallo son false.
  factory LoginState.loading(){
    //Retornamos los estados de la clase.
    return LoginState(isSuccess: false, isFailure: false);
  }
  //Declaramos el estado failure o fallo, donde el estado de failure es true.
  factory LoginState.failure(){
    //Retornamos los estados de la clase.
    return LoginState(isSuccess: false, isFailure: true);
  }
  //Declaramos el estado success o exito, donde el estado de success es true.
  factory LoginState.success(){
    //Retornamos los estados de la clase.
    return LoginState(isSuccess: true, isFailure: false);
  }
  //Esta funcion se puede usar para hacer una copia del estado. La cual se puede usar para monitorear mejor los estados.
  LoginState copyWith({
    bool isSuccess,
    bool isFailure,
  }){
    return LoginState(isSuccess: isSuccess??this.isSuccess, isFailure: isFailure??this.isFailure);
  }
  //Esta funcion solo se usa para imprimir los estados en el log ayudando a monitorearlos mejor.
  @override
  String toString() {
    return '''LoginState{
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}