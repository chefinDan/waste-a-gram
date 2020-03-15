import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as p;
import 'package:waste_a_gram/constants.dart';

class PostPhotoDto{
  String description;
  String weight;
  int quantity;
}

class PostImageScreen extends StatefulWidget{

  File image;
  PostImageScreen({this.image});

  @override
  _PostImageScreenState createState() => _PostImageScreenState();
}

class _PostImageScreenState extends State<PostImageScreen> {

  final formKey = GlobalKey<FormState>();
  final PostPhotoDto _postPhotoDto = PostPhotoDto();
  LocationData locationData;

  @override
  void initState() {
    var locationService = Location();
    locationService.getLocation().then((data) {
      locationData = data;
      setState(() {});
    });
    super.initState();
  }

  Widget _descriptionTextField(BuildContext context){
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        labelText: DESCRIPTION, border: OutlineInputBorder()
      ),
      validator: (value) { if(value.isEmpty) {return "$DESCRIPTION cannot be empty"; } return null; },
      onSaved: (value) => _postPhotoDto.description = value
    );
  }

  Widget _weightField(BuildContext context){
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        labelText: WEIGHT, border: OutlineInputBorder()
      ),
      validator: (value) { 
        if(value.isEmpty) { return "$WEIGHT cannot be empty"; }
        var parsed = int.tryParse(value);
        if(parsed == null) { return "$WEIGHT must be an integer number"; }
        else if(parsed < 1) { return "$WEIGHT must be positive"; } 
        return null;
        },
      onSaved: (value) => _postPhotoDto.weight = value,
    );
  }

  Widget _quantityField(BuildContext context){
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        labelText: QUANTITY, border: OutlineInputBorder()
      ),
      validator: (value) { 
        if(value.isEmpty) { return "$QUANTITY cannot be empty"; }
        var parsed = int.tryParse(value);
        if(parsed == null) { return "$QUANTITY must be an integer number"; }
        else if(parsed < 1) { return '$QUANTITY must be positive'; } 
        return null;
        },
      onSaved: (value) => _postPhotoDto.quantity = int.parse(value),
    );
  }
  

  Widget _postPhotoForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2),
            child: Image.file(widget.image, fit: BoxFit.fitHeight,)),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _descriptionTextField(context)
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _weightField(context)
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _quantityField(context)
                ),                
                SizedBox(height: 10),
                _postButton(context)
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _postButton(BuildContext context){
    return Builder(
      builder: (BuildContext context){
        return RaisedButton(
          child: Text('Post'),
          onPressed: () async {
            if(formKey.currentState.validate()){
              formKey.currentState.save();
              _postImage();
              Navigator.of(context).pop();
            }
          }
        );
      }
    );
  }

  String status(StorageUploadTask task) {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  Future _postImage() async {
    final String fileName = '${DateTime.now()}.${p.basename(widget.image.path)}';
    StorageReference storageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageRef.putFile(
      widget.image,
      StorageMetadata(
        customMetadata: <String, String>{'activity': 'test'},
      )
    );
    Firestore.instance.collection(POSTS).add({
      FILENAME: fileName, 
      DESCRIPTION: _postPhotoDto.description,
      WEIGHT: _postPhotoDto.weight,
      QUANTITY: _postPhotoDto.quantity,
      SUBMISSION_DATE: DateTime.now(),
      POST_LOCATION: GeoPoint(locationData.latitude, locationData.longitude)
    })
    .then((DocumentReference addResult) async {
      await uploadTask.onComplete;
      final imageUrl = await storageRef.getDownloadURL();
      Firestore.instance.collection(POSTS).document(addResult.documentID)
        .updateData({IMAGE_URL: imageUrl})
        .catchError((err) => print(err.toString()));
        
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _postPhotoForm(context)
    );
  }
}