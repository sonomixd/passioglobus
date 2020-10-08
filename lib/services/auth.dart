import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //facebook
  final fb = FacebookLogin();
  //google
  final GoogleSignIn googleSignIn = GoogleSignIn();

    Future<User> signInWithGoogleUser() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential userCredential =
        await _auth.signInWithCredential(googleCredential);
    final User firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(firebaseUser.uid == currentUser.uid);

      print('User successfully signed in with google: $firebaseUser');

      return firebaseUser;
    }
  }

   loginFacebook() async {
    print('Starting Facebook Login');

    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]
    );

    switch(res.status){
      case FacebookLoginStatus.Success:
      print('It worked');

      //Get Token
      final FacebookAccessToken fbToken = res.accessToken;

      //Convert to Auth Credential
      final AuthCredential credential 
        = FacebookAuthProvider.credential(fbToken.token);

      //User Credential to Sign in with Firebase
      final result = await _auth.signInWithCredential(credential);

      print('${result.user.displayName} is now logged in');

      break;
      case FacebookLoginStatus.Cancel:
      print('The user canceled the login');
      break;
      case FacebookLoginStatus.Error:
      print('There was an error');
      break;
    }
  }

  Stream<User> get currentUser => _auth.authStateChanges();



  Future<void> logout() => _auth.signOut();
}


