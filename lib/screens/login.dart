import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:passioglobus/screens/home.dart';
import 'package:passioglobus/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription<User> loginStateSubribtion;

  @override
  void initState() {
    var authBloc = Provider.of<AuthService>(context, listen: false);
    loginStateSubribtion = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubribtion.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(Buttons.Google,
            onPressed: () => authService.signInWithGoogleUser()),
            SignInButton(Buttons.Facebook,
                onPressed: () => authService.loginFacebook())
          ],
        ),
      ),
    );
  }
}
