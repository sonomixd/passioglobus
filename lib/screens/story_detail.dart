import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class StoryDetailsScreen extends StatefulWidget {
  final Map data;

  StoryDetailsScreen(this.data);

  @override
  _StoryDetailsScreenState createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(
      children: [
         BlurHash(
           imageFit: BoxFit.cover,
              hash: "TICSbN9Maf~QNIj?-lkAkAxYjbod",
              image: widget.data['image'],
         ),
      ],
    ));
  }
}
