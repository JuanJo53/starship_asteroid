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

   const Authenticated(this.displayName);

   @override
   List<Object>get props=> [displayName];

   @override String tiString()=> 'Autenticado - displayName: $displayName';
 }
 class Unauthenticated extends AuthenticationState{
   @override
   String toString()=> 'No autenticado';
 }