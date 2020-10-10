import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passioglobus/screens/home.dart';
import 'package:passioglobus/screens/story_detail.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class StoriesSlideshow extends StatefulWidget {
  @override
  _SlideshowState createState() => _SlideshowState();
}

class _SlideshowState extends State<StoriesSlideshow> {
  final PageController ctrl = PageController(viewportFraction: 0.8);

  final FirebaseFirestore db = FirebaseFirestore.instance;
  Stream slides;

  int currentPage = 0;

  String activeTag = 'topgames';

  List<Map<String, dynamic>> fullList = new List<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
    getData();

    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  Future<dynamic> getData({String tag = 'fustane'}) async {
    FirebaseFirestore.instance
        .collection("leagues")
        .where('tags', arrayContains: tag)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          Map<String, dynamic> map = element.data.call();
          fullList = new List<Map<String, dynamic>>();
          fullList.add(map);
          
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
            controller: ctrl,
            itemCount: fullList.length + 1,
            itemBuilder: (context, int currentIdx) {
              if (currentIdx == 0) {
                return _buildTagPage();
              } else if (fullList.length >= currentIdx) {
                return _buildStoryPage(fullList[currentIdx - 1]);
              } else
                return Container();

            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          onPressed: () => ctrl.animateToPage(0,
              duration: Duration(milliseconds: 200), curve: Curves.bounceOut),
        ));
  }

  _buildStoryPage(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StoryDetailsScreen(data),
        ),
      ),
      child:Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(-20, 10),
          ),
        ]),
        margin: EdgeInsets.only(top: 40, bottom: 100, right: 40),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BlurHash(
                imageFit: BoxFit.cover,
                hash: "TICSbN9Maf~QNIj?-lkAkAxYjbod",
                image: data['image'],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                  Colors.green.withOpacity(.8),
                  Colors.white.withOpacity(.0),
                ]),
              ),
            ),
          ],
        )));
  }

  _buildTagPage() {
    return Container(
        child: ListView(
      padding: EdgeInsets.only(top: 40, right: 50),
      children: <Widget>[
        Text(
          'KATEGORITE',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text('FILTER', style: TextStyle(color: Colors.black26)),
        _buildButton('topgames'),
        _buildButton('championsleague'),
        _buildButton('europaleague'),
        _buildButton('premierleague'),
        _buildButton('laliga'),
        _buildButton('bundesliga'),
        _buildButton('seriea'),
        _buildButton('ligue1'),
      ],
    ));
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.green : Colors.red;
    return FlatButton(
        color: color,
        child: Text('#$tag'),
        onPressed: () {
          activeTag = tag;
          getData(tag: tag);
        });
  }
}
