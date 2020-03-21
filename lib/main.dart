import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeLeft, 
      DeviceOrientation.portraitUp, 
      DeviceOrientation.landscapeRight
    ]
  );
  
  final app = App(
    preferences: await SharedPreferences.getInstance(),
    firestore: Firestore.instance,
    storage: FirebaseStorage.instance
  );

  runApp(app);
}