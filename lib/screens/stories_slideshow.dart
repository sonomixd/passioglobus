import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passioglobus/screens/home.dart';
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

  String activeTag = 'topgames';

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _queryDb();

    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: slides,
      initialData: [],
      builder: (context, AsyncSnapshot snap) {
        //

        List slideList = snap.data.toList();
        Map<String, dynamic> map = slideList[0];

        return PageView.builder(
          controller: ctrl,
          itemCount: slideList.length + 1,
          itemBuilder: (context, int currentIdx) {
            if (currentIdx == 0) {
              return _buildTagPage();
            } else if (slideList.length >= currentIdx) {
              bool active = currentIdx == currentPage;
              //return _buildStoryPage(slideList[currentIdx - 1], active);
              if (active) {
                return Container(
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
                            image: "slideList[currentIdx - 1]",
                          ),
                          // child: FadeInImage.assetNetwork(
                          //   height: double.infinity,
                          //   fit: BoxFit.cover,
                          //   placeholder: 'assets/images/loading-leaf.png',
                          //   image: data['img'],
                          // ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.green.withOpacity(.8),
                                  Colors.white.withOpacity(.0),
                                ]),
                          ),
                        ),
                      ],
                    ));
              }
            } else
              return Container();
          },
        );
      },
    );
  }

  void _queryDb({String tag = 'topgames'}) {
    Query query = db.collection('leagues').where('tags', arrayContains: tag);

    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    setState(() {
      activeTag = tag;
    });
  }

  _buildStoryPage(Map<String, dynamic> data, bool active) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 0;

    return Container(
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
              // child: FadeInImage.assetNetwork(
              //   height: double.infinity,
              //   fit: BoxFit.cover,
              //   placeholder: 'assets/images/loading-leaf.png',
              //   image: data['img'],
              // ),
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
        ));
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
        _buildButton('fustane'),
        _buildButton('funde'),
        _buildButton('t-shirt'),
        _buildButton('pulover'),
        _buildButton('kemisha'),
        _buildButton('xhaketa'),
        _buildButton('pallto'),
        _buildButton('xhinse'),
        _buildButton('shorts'),
        _buildButton('pantallona'),
        _buildButton('shoes'),
        _buildButton('canta'),
        _buildButton('aksesore'),
      ],
    ));
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.green : Colors.white;
    return FlatButton(
        color: color,
        child: Text('#$tag'),
        onPressed: () => _queryDb(tag: tag));
  }
}
