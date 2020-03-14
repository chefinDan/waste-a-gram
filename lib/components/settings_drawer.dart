import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/screens/home_screen.dart';

class SettingsDrawer extends StatefulWidget{

  bool switchValue; 
  final Function updateState;

  SettingsDrawer({this.updateState, this.switchValue});

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
            child: Text('Change App Theme', style: Theme.of(context).textTheme.body2),
          ),
          Switch(
            value: context.findAncestorStateOfType<HomeScreenState>().switchVal, 
            onChanged: widget.updateState
          ),
        ],
      )
    );
  }
}