import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/screens/home_screen.dart';

class App extends StatefulWidget {
  App({Key key, this.preferences, this.firestore, this.storage}) : super(key: key);
  
  final SharedPreferences preferences;
  final Firestore firestore;
  final FirebaseStorage storage;

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste-a-gram',
      theme: ThemeData.light(),
      home: HomeScreen(
        title: 'Waste-a-gram',
        preferences: widget.preferences,
        firestore: widget.firestore,
        storage: widget.storage
      ),
    );
  }
}
