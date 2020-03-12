import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/screens/camera.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.updateState, this.preferences }) : super(key: key);

  final String title;
  final Function updateState;
  final SharedPreferences preferences;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> { 

  // -- state
  var _entries = [];
  bool switchVal;
  // -- 

  bool get getSwitchVal => widget.preferences.getBool(SWITCH_VALUE);
  void saveSwitchVal(bool val) => widget.preferences.setBool(SWITCH_VALUE, val);
  
  void updateSwitch(newVal){
    setState(() {
      switchVal = newVal;
    });
    saveSwitchVal(switchVal);
    // widget.preferences.setBool(SWITCH_VALUE, switchVal);
    widget.updateState(); 
  }

  Widget drawer(BuildContext context){
    return Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
              child: Text('Change App Theme', style: Theme.of(context).textTheme.body2),
            ),
            Switch(value: switchVal, onChanged: updateSwitch),
          ],
        )
      );
  }

  Widget postList = StreamBuilder(
    stream: Firestore.instance.collection('posts').snapshots(),
    builder: (context, snapshot){
      if(snapshot.hasData){
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            var post = snapshot.data.documents[index];
            return ListTile(
              leading: Text(post['weight'].toString()),
              title: Text('Post Title'),
            );
          }
        );
      }else{
        return Center(child: CircularProgressIndicator());
      }
    }
  );

  @override void initState() {
    try{
      switchVal = getSwitchVal ? true : false;
    }
    catch(err){
      switchVal = false;
      saveSwitchVal(switchVal);
      print(err);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      endDrawer: drawer(context),
      body: postList,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Camera() ));
        },
        child: Icon(Icons.add),  
      ),
    );
  }

  
}