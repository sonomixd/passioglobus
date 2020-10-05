import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get currentUser => _auth.authStateChanges();
  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
  Future<void> logout() => _auth.signOut();
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:passioglobus/helpers/screen_navigation.dart';
// import 'package:passioglobus/helpers/user.dart';
// import 'package:passioglobus/models/user.dart';
// import 'package:passioglobus/screens/home.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:shared_preferences/shared_preferences.dart';

/**
 * Enum for the user status
 * Uninitialized -> nothing is initialized -> show Splashsreen
 * Unauthenticated -> user is not authenticated -> show Login screen
 * Authenticated -> user is authenticated -> show Home screen
 * Authenticating -> user is authenticating -> show loading item
 */
// enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

// class AuthService with ChangeNotifier {
//   static const LOGGED_IN = "loggedIn";
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   User _user;
//   Status _status = Status.Uninitialized;
//   UserServices _userServices = UserServices();
//   UserModel _userModel;
//   TextEditingController phoneNumberController;
//   String smsOTP;
//   String verificationId;
//   String errorMessage = '';
//   bool loggedIn;
//   bool loading = false;

//   //google sign in
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   Stream<User> user;
//   Stream<Map<String, dynamic>> profile;
//   PublishSubject loadingg = PublishSubject();

//   UserModel get userModel => _userModel;
//   Status get status => _status;
//   User get user1 => _user;

//   AuthService.initialize() {
//     //get shared prefences when apps starts
//     getSharedPreferences();
//   }

//   Future<void> getSharedPreferences() async {
//     //wait 3 seconds until Splashscreen finishes
//     await Future.delayed(Duration(seconds: 3)).then((v) async {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       loggedIn = preferences.getBool(LOGGED_IN) ?? false;

//       if (loggedIn) {
//         //get the current user if is logged in
//         _user = _auth.currentUser;
//         _userModel = await _userServices.getUserById(_user.uid);
//         _status = Status.Authenticated;
//         // letting all the listeners to know the new values of this variable
//         notifyListeners();
//         return;
//       }
//       _status = Status.Unauthenticated;
//       notifyListeners();
//     });
//   }

//   //method to verify phone number
//   Future<void> verifyPhone(BuildContext context, String number) async {
//     //check if sms OTP is sent
//     final PhoneCodeSent smsOTPSent =
//         (String verificationId, [int forceCodeResend]) {
//       this.verificationId = verificationId;
//       smsOTPDialog(context).then((value) {
//         print('sign in');
//       });
//     };
//     try {
//       await _auth.verifyPhoneNumber(
//           phoneNumber: number.trim(),
//           timeout: const Duration(seconds: 60),
//           verificationCompleted: (AuthCredential phoneAuthCredential) {
//             print(phoneAuthCredential.toString());
//           },
//           verificationFailed: (FirebaseAuthException exception) {
//             print('${exception.message}');
//           },
//           codeSent: smsOTPSent,
//           codeAutoRetrievalTimeout: (String verId) {
//             this.verificationId = verId;
//           });
//     } catch (error) {
//       handleError(error, context);
//       errorMessage = error.toString();
//       notifyListeners();
//     }
//   }

//   //create and save user in firestore database
//   void createUser({String id, String phoneNumber}) {
//     _userServices.createUser({
//       "id": id,
//       "phoneNumber": phoneNumber,
//     });
//   }

//   Future<void> signIn(BuildContext context) async {
//     try {
//       final AuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: verificationId, smsCode: smsOTP);
//       final UserCredential user = await _auth.signInWithCredential(credential);
//       final User currentUser = _auth.currentUser;
//       assert(user.user.uid == currentUser.uid);
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       preferences.setBool(LOGGED_IN, true);
//       loggedIn = true;
//       if (user != null) {
//         _userModel = await _userServices.getUserById(user.user.uid);
//         if (_userModel == null) {
//           createUser(id: user.user.uid, phoneNumber: user.user.phoneNumber);
//         }

//         loading = false;
//         Navigator.of(context).pop();
//         changeScreenReplacement(context, HomeScreen());
//       }
//       loading = false;
//       Navigator.of(context).pop();
//       changeScreenReplacement(context, HomeScreen());
//       notifyListeners();
//     } catch (error) {
//       print("${error.toString()}");
//     }
//   }

//   Future<bool> smsOTPDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Enter SMS code'),
//             content: Container(
//               height: 85,
//               child: Column(
//                 children: [
//                   TextField(
//                     onChanged: (value) {
//                       this.smsOTP = value;
//                     },
//                   )
//                 ],
//               ),
//             ),
//             contentPadding: EdgeInsets.all(10),
//             actions: [
//               FlatButton(
//                 child: Text("Done"),
//                 onPressed: () async {
//                   loading = true;
//                   notifyListeners();
//                   User user = _auth.currentUser;
//                   if (user != null) {
//                     _userModel = await _userServices.getUserById(user.uid);
//                     if (_userModel == null) {
//                       createUser(id: user.uid, phoneNumber: user.phoneNumber);
//                     }
//                     Navigator.of(context).pop();
//                     loading = false;
//                     notifyListeners();
//                     changeScreenReplacement(context, HomeScreen());
//                   } else {
//                     loading = true;
//                     notifyListeners();
//                     Navigator.of(context).pop();
//                     loading = false;
//                     signIn(context);
//                   }
//                 },
//               )
//             ],
//           );
//         });
//   }

//   handleError(error, BuildContext context) {
//     print(error);
//     errorMessage = error.toString();
//     notifyListeners();
//     switch (error.code) {
//       case 'ERROR_INVALID_VERIFICATION_CODE':
//         print("The verification code is invalid");
//         break;
//       default:
//         errorMessage = error.message;
//         break;
//     }
//     notifyListeners();
//   }
// }
