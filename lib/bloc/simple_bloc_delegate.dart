import 'package:bloc/bloc.dart';
/*Esta clase ayuda a monitoriar los eventos, las transiciones de estados 
indicando el estado actual y el que sigue. Ademas de imprimir si existe algun error.*/
class SimpleBlocDelegate extends BlocDelegate {
  @override
  //Monitoriamos el evento actual.
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }
  //Monitoreamos si existe algun error.
  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
  //Monitoreamos la transicion de estados.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}