import "package:firebase_auth/firebase_auth.dart";

class AuthService{
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static FirebaseUser currentUser;

  static Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  static Future<FirebaseUser> registerWithEmailAndPassword(String name, String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    //Add the user's name to the recently created user
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = name;
    user.updateProfile(updateInfo);
    user.reload();
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