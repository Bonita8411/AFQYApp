import "package:firebase_auth/firebase_auth.dart";

class AuthService{
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static FirebaseUser currentUser;

  static Future<FirebaseUser> signInWithEmailAndPassword(String email, String password){
    return null;
  }

  static Future<FirebaseUser> registerWithEmailAndPassword(String name, String email, String password) async {
    print(name + " " + email + " " + password);
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = name;
    user.updateProfile(updateInfo);
    print(user.displayName);
    return user;
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