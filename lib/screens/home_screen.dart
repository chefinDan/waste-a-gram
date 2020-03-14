import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/components/dismissible_background.dart';
import 'package:waste_a_gram/components/food_list_tile.dart';
import 'package:waste_a_gram/components/settings_drawer.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/screens/select_image_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.updateState, this.preferences }) : super(key: key);

  final String title;
  final Function updateState;
  final SharedPreferences preferences;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> { 

  // -- state
  bool switchVal;
  Stream<QuerySnapshot> _postStream;
  // -- 

  bool get getSwitchVal => widget.preferences.getBool(SWITCH_VALUE);
  void saveSwitchVal(bool val) => widget.preferences.setBool(SWITCH_VALUE, val);
  
  void updateSwitch(newVal){
    setState(() {
      switchVal = newVal;
    });
    saveSwitchVal(switchVal);
    widget.updateState(); 
  }

  static void onDismissed(DocumentSnapshot snapshot){
    Firestore.instance.runTransaction(
      (Transaction transaction) {
        return transaction.delete(snapshot.reference);
      }
    );
  }

  static Widget postListTile(DocumentSnapshot snapshot){
    var post = snapshot;
    return Dismissible(
      background: DismissibleBackground(direction: LEFT_TO_RIGHT, color: Colors.redAccent),
      secondaryBackground: DismissibleBackground(direction: RIGHT_TO_LEFT, color: Colors.redAccent),
      onDismissed: (_) => onDismissed(snapshot),
      key: Key(post.hashCode.toString()), 
      child: FoodWasteItem(
        thumbnail: post[IMAGE_URL],
        description: post[DESCRIPTION],
        weight: post[WEIGHT],
        submissionDate: (post[SUBMISSION_DATE] as Timestamp).toDate(),
      )
    );
  }

  Widget _postListBuilder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if(snapshot.hasData){
      if(snapshot.data.documents.length == 0){
        return Center(child: Text('You have no photos', style: Theme.of(context).textTheme.display1,));
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: snapshot.data.documents.length,
        reverse: true,
        itemBuilder: (context, index){
          return postListTile(snapshot.data.documents[index]);
        },
      );
    }else{
      return Center(child: CircularProgressIndicator());
    }
  }

  @override void initState() {
    try{
      switchVal = getSwitchVal ? true : false;
    }
    catch(err){
      switchVal = false;
      saveSwitchVal(switchVal);
      print(err);
    }
    _postStream = Firestore.instance.collection('posts').orderBy(SUBMISSION_DATE, descending: true).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      endDrawer: SettingsDrawer(updateState: updateSwitch),
      body: StreamBuilder<QuerySnapshot>(
        stream: _postStream,
        builder: _postListBuilder
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectImageScreen() ));
        },
        child: Icon(Icons.add),  
      ),
    );
  }
}