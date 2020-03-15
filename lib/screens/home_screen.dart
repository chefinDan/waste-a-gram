import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  StreamBuilder _foodWasteStreamBuilder;
  Stream<QuerySnapshot> _foodWasteStream;
  int _foodWasteTotal;
  List<DocumentSnapshot> _docSnapshots = [];
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
  

  Widget _postListBuilder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if(snapshot.hasData){
      if(snapshot.data.documents.length == 0){
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index){
          DocumentSnapshot post = snapshot.data.documents[index];
          _docSnapshots.add(post);
          return FoodWasteTile(
            snapshot: post,
            onDelete: (){
              StorageReference fileRef = FirebaseStorage.instance.ref().child(post[FILENAME]);
              fileRef.delete().catchError((err) => print(err));
              Firestore.instance.runTransaction(
                (Transaction transaction) {
                  return transaction.delete(post.reference);
                }
              );
            }
          );
        },
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
        print(_foodWasteTotal);
    });
  }

  @override 
  void initState() {
    try{
      switchVal = getSwitchVal ? true : false;
    }
    catch(err){
      switchVal = false;
      saveSwitchVal(switchVal);
      print(err);
    }
    _foodWasteStream = Firestore.instance.collection('posts').orderBy(SUBMISSION_DATE, descending: true).snapshots().asBroadcastStream();
    _foodWasteStreamBuilder = StreamBuilder<QuerySnapshot>(
      stream: _foodWasteStream,
      builder: _postListBuilder,
    );
    setState(() {});
    updateFoodWasteTotalCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[300],
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.title, 
                style: TextStyle(
                  shadows: [
                    Shadow(
                      color: Colors.deepOrange[500], 
                      offset: Offset(2, 2)
                    )
                  ],
                  fontSize: 24

                ),
              ), 
              Text(_foodWasteTotal.toString())
            ]
          ),
        ),
      ),
      endDrawer: SettingsDrawer(updateState: updateSwitch),
      body: _foodWasteStreamBuilder,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectImageScreen() ));
        },
        child: Icon(Icons.add),  
      ),
    );
  }
}