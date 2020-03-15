import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_a_gram/app.dart';
import 'package:waste_a_gram/components/custom_text.dart';
import 'package:waste_a_gram/components/food_waste_tile.dart';
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
  int _foodWasteTotal;
  Stream<QuerySnapshot> _foodWasteStream;
  List<Widget> stackChildren = [];
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


  void _onDelete(DocumentSnapshot post) async {
    try{
      await FirebaseStorage.instance.ref().child(post[FILENAME]).delete();
      Firestore.instance.runTransaction(
        (Transaction transaction) {
          transaction.delete(post.reference);
        }
      );
    } on Exception catch(err){
      print(err.toString());
    }
  }

  void _onTapped(){
    stackChildren.add(
      GestureDetector(
        onTap: (){
          stackChildren.removeLast();
          setState(() {});
        },
        child: Container(
          color: Colors.black54,
          alignment: Alignment.topCenter,
          padding: new EdgeInsets.only(
            top: MediaQuery.of(context).size.height/4,
            right: 20.0,
            left: 20.0
          ),
          child: GestureDetector(
            onTap: (){},
            child: new Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: new Card(
                color: Colors.white,
                elevation: 4.0,
              ),
            ),
          )
        ),
      ));
    setState(() {});
  }

  Widget _foodListBuilder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if(snapshot.hasData){
      if(snapshot.data.documents.length == 0){
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index){
          DocumentSnapshot post = snapshot.data.documents[index];
          return FoodWasteTile(
            snapshot: post,
            onDelete: () {
              _onDelete(post);
            },
            onTapped: () {
              _onTapped();
            },
          );
        }
      );
    }else{
      return Center(child: CircularProgressIndicator());
    }
  }

  void updateFoodWasteTotalCount(){
    _foodWasteStream.listen((QuerySnapshot querySnapshot) {
      _foodWasteTotal = 0;
      querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
        setState(() {
          _foodWasteTotal += documentSnapshot.data[QUANTITY];
        });
      });
    });
  }

  @override 
  void initState() {
    super.initState();
    try{
      switchVal = getSwitchVal ? true : false;
    }
    catch(err){
      switchVal = false;
      saveSwitchVal(switchVal);
      print(err);
    }
    _foodWasteStream = Firestore.instance.collection('posts').orderBy(SUBMISSION_DATE, descending: true).snapshots().asBroadcastStream();
    stackChildren.insert(0,StreamBuilder<QuerySnapshot>(
      stream: _foodWasteStream,
      builder: _foodListBuilder,
    ));
    updateFoodWasteTotalCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getSwitchVal ? Colors.blueGrey[800]: Colors.deepOrange[300],
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              appBarTitle(widget.title), 
              Text(_foodWasteTotal.toString())
            ]
          ),
        ),
      ),
      body: Stack(
        children: stackChildren, 
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