/*En esta clase es donde se controlaran los cambios de estado del BLOC de la autenticacion.
Aqui haremos referencia a los estados de autenticado, no autenticado y no inicializado 
cuando iniciamos la aplicacion. */
abstract class AuthenticationState{
  const AuthenticationState();   
  @override 
  List<Object> get props=>[];//Lista donde tenemos los datos que pueden viajar a travez de estos estados.
}
//Estado de no inicializado, que imprime el mensaje respectivo.
class Uninitialized extends AuthenticationState{
  @override 
  String toString()=>'No inicializado';
}
//Estado de autenticado, que declara los datos del usuario autenticado.
class Authenticated extends AuthenticationState{
  final String displayName;//Nombre del usuario autenticado
  final String urlImage;//URL de la imagen del usuario autenticado
  
  //Constructor con sus parametros respectivos.
  const Authenticated(this.displayName, this.urlImage);
  //Le pasamos a nuestro props los datos del usuario.
  @override
  List<Object>get props=> [displayName,urlImage];
  //Imprime el estado de autenticado junto con el nombre del usuario.
  @override String toString()=> 'Autenticado - displayName: $displayName';
}
//Estado de no autenticado, que imprime el estado de no autenticado.
class Unauthenticated extends AuthenticationState{
  @override
  String toString()=> 'No autenticado';
}