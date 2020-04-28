import "package:firebase_auth/firebase_auth.dart";

class AuthService{
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<FirebaseUser> signInWithEmailAndPassword(String email, String password){
    return null;
  }

  static Future signOut() async{
    return await _firebaseAuth.signOut();
  }

  static Future<FirebaseUser> signInAnon() async {
    AuthResult result = await _firebaseAuth.signInAnonymously();
    FirebaseUser user = result.user;
    return user;
  }
}