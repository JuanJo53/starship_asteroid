/*En esta clase solo declaramos los eventos del BLOC para el login como clases que extienden a LoginEvent.
En este caso solo es uno, y es cuando se presional el boton para iniciar sesion con Google.
Aqui se deben añadir mas eventos si se piensa añadir mas metodos de autentificacion. */
abstract class LoginEvent {
  const LoginEvent();
  @override
  List<Object>get props=>[];

}
class LoginWithGooglePressed extends LoginEvent{}