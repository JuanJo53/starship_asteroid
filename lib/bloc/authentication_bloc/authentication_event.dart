abstract class AuthenticationEvent{
  const AuthenticationEvent();

  @override 
  List<Object>get props=>[];

}

class AppStarted extends AuthenticationEvent{}
class LoggedIn extends AuthenticationEvent{}
class LoggedOut extends AuthenticationEvent{}