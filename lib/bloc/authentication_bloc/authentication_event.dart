/*En esta clase solo declaramos los eventos del BLOC para la autenticacion como clases que extienden a AutenticationEvent.
En este caso son tres: AppStarted, LoggedIn y LoggedOut.
Aqui se deben añadir mas eventos si se piensa añadir mas metodos de autentificacion. */
abstract class AuthenticationEvent{
  const AuthenticationEvent();
  @override 
  List<Object>get props=>[];
}
class AppStarted extends AuthenticationEvent{}//Evento cuando la aplicacion inicia
class LoggedIn extends AuthenticationEvent{}//Evento cuando existe un usuario autenticado
class LoggedOut extends AuthenticationEvent{}//Evento cuando no existe un usuario autenticado.
