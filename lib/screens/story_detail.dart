import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:passioglobus/screens/stepper.dart';

class StoryDetailsScreen extends StatefulWidget {
  final Map data;

  StoryDetailsScreen(this.data);

  @override
  _StoryDetailsScreenState createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  int score;
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BlurHash(
          imageFit: BoxFit.cover,
          hash: "TICSbN9Maf~QNIj?-lkAkAxYjbod",
          image: widget.data['image'],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StepperTouch(
              initialValue: 0,
              direction: Axis.vertical,
              withSpring: false,
              onChanged: (value) => score = value),
        ),
        Center(
          child: MaterialButton(
            child: Text("create"),
            onPressed: () async {
              await create();
            },
          ),
        ),
      ],
    ));
  }

  Future<void> create() async {
    await Firebase.initializeApp();

    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user.uid).set({"name": user.displayName, "score": score});
    return;
  }
}
