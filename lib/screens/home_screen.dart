import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/components/addPostButton.dart';
import 'package:waste_a_gram/components/appBarContent.dart';
import 'package:waste_a_gram/components/food_waste_tile.dart';
import 'package:waste_a_gram/components/post_detail_card.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/screens/select_image_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.preferences, this.firestore, this.storage}) : 
    stream = firestore
      .collection(POSTS)
      .orderBy(SUBMISSION_DATE, descending: true)
      .snapshots(),
    super(key: key);

  final String title;
  final SharedPreferences preferences;
  final Firestore firestore;
  final Stream<QuerySnapshot> stream;
  final StorageReference storage;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // -- state
  bool switchVal;
  int _foodWasteTotal;
  List<Widget> stackChildren = [];
  // --

  Widget _foodListBuilder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data.documents.length == 0) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          DocumentSnapshot post = snapshot.data.documents[index];
          return FoodWasteTile(
            postData: post,
            onDelete: () {
              _onDelete(post);
            },
            onTapped: () {
              _onTapped(post);
            },
          );
        }
      );
    } 
    else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void _onDelete(DocumentSnapshot post) async {
    try {
      await widget.storage.child(post[FILENAME]).delete();
    } on Exception catch (err) {
      print(err.toString());
    }
    widget.firestore.runTransaction((Transaction transaction) {
      return transaction.delete(post.reference);
    });
  }
  

  void _onTapped(DocumentSnapshot post) {
    final Future<Uint8List> imageData = widget.storage
      .child(post[FILENAME])
      .getData(ONE_MEGABYTE*10);

    stackChildren.add(
      GestureDetector(
        onTap: () {
        stackChildren.removeLast();
          setState(() {});
        },
        child: PostDetailCard(
          post: post,
          imageStream: imageData.asStream() 
        )
      )
    );
    setState(() {});
  }

  int sumTotalWaste(QuerySnapshot snapshot){
    return snapshot.documents.fold(0, (prev, DocumentSnapshot curr) => prev + curr.data[QUANTITY]); 
  }

  Widget _floatingActionButton(){
    return (stackChildren.length == 1) ? 
      AddPostButton(
        onPressed: (){
          Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SelectImageScreen()));
          },
      ) : Container();
  }

  @override
  void initState() {
    super.initState();
    if (stackChildren.length != 0) {
      stackChildren.clear();
    }
    stackChildren.insert(0, StreamBuilder<QuerySnapshot>(
      stream: widget.stream,
      builder: _foodListBuilder,
    ));
    widget.stream.map<int>(sumTotalWaste)
      .listen((int total) {
        _foodWasteTotal = total;
        setState(() {});
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[300],
        title: AppBarTitle(
          title: widget.title,
          foodWasteTotal: _foodWasteTotal,
        ),
        actions: [
          AppBarActions.sort()
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _floatingActionButton(),
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}