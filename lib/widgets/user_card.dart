import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passioglobus/models/user.dart';

Widget userCard(BuildContext context, DocumentSnapshot document) {
  final user = UserModel.fromSnapshot(document);

  return new Container(
    child: Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(children: <Widget>[
                  Text(
                    user.username,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red, ),
                  ),
                  Spacer(),
                  Text(
                    user.points.toString(),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}