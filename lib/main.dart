import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passioglobus/blocs/auth_bloc.dart';
import 'package:passioglobus/screens/login.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
          title: 'Passioglobus',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginScreen()),
    );
  }
}

// class ScreensController extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);
//       if(auth.status == Status.Uninitialized) {
//         return LoginScreen();
//       }else{
//         if(auth.loggedIn){
//           return HomeScreen();
//         }else {
//           return LoginScreen();
//         }
//       }
//     }
//   }
