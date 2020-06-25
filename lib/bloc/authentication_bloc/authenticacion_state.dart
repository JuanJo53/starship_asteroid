abstract class AuthenticationState{
  const AuthenticationState();   
  @override 
  List<Object> get props=>[];
}

class Uninitialized extends AuthenticationState{
  @override 
  String toString()=>'No inicializado';
}

class Authenticated extends AuthenticationState{
  final String displayName;
  final String urlImage;

  const Authenticated(this.displayName, this.urlImage);

  @override
  List<Object>get props=> [displayName,urlImage];

  @override String toString()=> 'Autenticado - displayName: $displayName';
}
class Unauthenticated extends AuthenticationState{
  @override
  String toString()=> 'No autenticado';
}