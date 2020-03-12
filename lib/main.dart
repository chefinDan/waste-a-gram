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

  runApp(App(preferences: await SharedPreferences.getInstance()));
}

