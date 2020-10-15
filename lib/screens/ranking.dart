import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passioglobus/models/user.dart';
import 'package:passioglobus/widgets/user_card.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  TextEditingController searchController = TextEditingController();
  List userList = [];
  List searchResultList = [];
  Future userListLoaded;

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userListLoaded = orderUsersByScore();
  }

    onSearchChanged() {
    searchResultsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: searchResultList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          userCard(context, searchResultList[index])),
                  // child: StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance
                  //       .collection('users')
                  //       .orderBy('score', descending: true)
                  //       .snapshots(),
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<QuerySnapshot> snapshot) {
                  //     if (snapshot == null) {
                  //       return Container();
                  //     } else {
                  //       return ListView(children: orderByPoints(snapshot));
                  //     }
                  //   },
                  // ),
                )
              ],
            )));
  }

  orderByPoints(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new ListTile(
            dense: true,
            title: new Text(doc["name"]),
            leading: new Text("1"),
            trailing: new Text(doc["score"].toString())))
        .toList();
  }

  orderUsersByScore() async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('points', descending: true)
        .get();

    setState(() {
      userList = data.docs;
      searchResultsList();
    });
    return "loaded user list";
  }

    searchResultsList() {
    var showResults = [];

    if(searchController.text != "") {
      for(var userSnapshot in userList){
        var title = UserModel.fromSnapshot(userSnapshot).username.toLowerCase();

        if(title.contains(searchController.text.toLowerCase())) {
          showResults.add(userSnapshot);
        }
      }

    } else {
      showResults = List.from(userList);
    }
    setState(() {
      searchResultList = showResults;
    });
  }
}
