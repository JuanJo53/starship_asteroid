import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository{
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
    _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle()async{
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential= GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();    
  }

  Future<void> signOut()async{
    return Future.wait([_googleSignIn.signOut(),_firebaseAuth.signOut(),]);
  }

  Future <bool> isSignedIn()async{
    final currenteUser = await _firebaseAuth.currentUser();
    return currenteUser != null;
  }

  Future<String> getUser()async{
    return (await _firebaseAuth.currentUser()).displayName; 
  }
  Future<String> getUserImage()async{
    return (await _firebaseAuth.currentUser()).photoUrl; 
  }
  
}