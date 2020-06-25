import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository{
  final FirebaseAuth _firebaseAuth;//Parametro para la autenticacion con firebase
  final GoogleSignIn _googleSignIn;//Parametro para el inicio de sesion con Google

  //Constructor con los parametros respectivos.
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,//Instanciamos la autenticacion de Firebase
    _googleSignIn = googleSignIn ?? GoogleSignIn();//Instanciamos el inicio de sesioncon google

  //Funcion para iniciar sesion con google.
  Future<FirebaseUser> signInWithGoogle()async{
    //Aqui se hace el signin con google
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    //Aqui se hace la uatenticacion con google
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    //Declaramos las credenciales para la autenticacion con google. Donde obtenemos el access token y el id token.
    final AuthCredential credential= GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    //Usamos las credenciales para autenticarnos en firebase.
    await _firebaseAuth.signInWithCredential(credential);
    //Retornamos al usuario autenticado
    return _firebaseAuth.currentUser();    
  }
  //Funcion que realiza el signOut
  Future<void> signOut()async{
    return Future.wait([_googleSignIn.signOut(),_firebaseAuth.signOut(),]);
  }
  //Funcion que retorna si existe un usuario autenticado
  Future <bool> isSignedIn()async{
    final currenteUser = await _firebaseAuth.currentUser();
    return currenteUser != null;
  }
  //Retorna el nombre del usuario autenticado
  Future<String> getUser()async{
    return (await _firebaseAuth.currentUser()).displayName; 
  }
  //Retorna la URL de la imagen del usuario autenticado
  Future<String> getUserImage()async{
    return (await _firebaseAuth.currentUser()).photoUrl; 
  }
}