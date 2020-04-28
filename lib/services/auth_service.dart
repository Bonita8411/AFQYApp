import "package:firebase_auth/firebase_auth.dart";

class AuthService{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> SignInWithEmailAndPassword(String email, String password){
    return null;
  }

  Future SignOut(){
    return null;
  }
}