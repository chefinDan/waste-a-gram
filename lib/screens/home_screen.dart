import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/components/addPostButton.dart';
import 'package:waste_a_gram/components/appBarContent.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/models/post.dart';
import 'package:waste_a_gram/models/post_list.dart';
import 'package:waste_a_gram/screens/select_image_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.preferences, this.firestore, this.storage}) : 
    postCollection = firestore.collection(POSTS),
    super(key: key);

  final String title;
  final SharedPreferences preferences;
  final Firestore firestore;
  final CollectionReference postCollection;
  final FirebaseStorage storage;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // -- state
  int _foodWasteTotal;
  PostList _postList;
  Future<Uint8List> tappedImageData;
  // --

  void _onDelete(Post post) async {
    try {
      await widget.storage.ref().child(post.filename).delete();
    } on Exception catch (err) {
      print(err.toString());
    }
    widget.firestore.runTransaction((Transaction transaction) {
      return transaction.delete(post.snapshotReference);
    });
    setState(() {
      _foodWasteTotal = _postList.totalWaste;
    });
  }
  

  void _onTapped(Post tappedPost) {
    tappedImageData = widget.storage.ref()
      .child(tappedPost.filename)
      .getData(ONE_MEGABYTE*10);
    setState(() {});
  }

  int sumTotalWaste(QuerySnapshot snapshot){
    return snapshot.documents.fold(0, (prev, DocumentSnapshot curr) => prev + curr.data[QUANTITY]); 
  }

  @override
  void initState() {
    super.initState();
    _postList = PostList.fromStream(
      widget.postCollection
        .orderBy(SUBMISSION_DATE, descending: true)
        .snapshots()
    );
    _postList.listen(_setState);
  }
  
  void _setState(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _foodWasteTotal = _postList.totalWaste;
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
      floatingActionButton: AddPostButton(
        onPressed: (){
          Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SelectImageScreen()));
        },
      ),
      body: _postList.build(
        tappedImageData, 
        onTapped: _onTapped, 
        onDelete: _onDelete
      )
    );
  }
}