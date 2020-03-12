import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/screens/home_page.dart';

class App extends StatefulWidget {
  final SharedPreferences preferences;

  App({Key key, this.preferences}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {

  ThemeData themeData;

  bool get isDarkTheme => widget.preferences.getBool(DARK_THEME);
  void setTheme (bool tf) => widget.preferences.setBool(DARK_THEME, tf);

  void updateTheme(){
    setState(() {
      themeData = isDarkTheme ? ThemeData.light() : ThemeData.dark();
    });
    setTheme(!isDarkTheme);
  }

  @override
  void initState(){
    super.initState();
    try{
      themeData = isDarkTheme ? ThemeData.dark(): ThemeData.light();
    }
    catch(err){
      setTheme(false);
      print(err);
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste-a-gram',
      theme: themeData,
      home: HomePage(
        title: 'Waste-a-gram', 
        updateState: updateTheme, 
        preferences: widget.preferences
      ),
    );
  }
}