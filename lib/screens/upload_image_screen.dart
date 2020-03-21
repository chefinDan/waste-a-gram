import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as p;
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/models/post.dart';

class UploadImageScreen extends StatefulWidget{

  final Post post;
  UploadImageScreen({File image}) : this.post = Post(image: image);

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  final formKey = GlobalKey<FormState>();
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
      onSaved: (value) => widget.post.description = value
    );
  }

  Widget _weightField(BuildContext context){
    return TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        labelText: WEIGHT + ' (oz)', border: OutlineInputBorder()
      ),
      validator: (value) { 
        if(value.isEmpty) { return "$WEIGHT cannot be empty"; }
        var parsed = int.tryParse(value);
        if(parsed == null) { return "$WEIGHT must be an integer number"; }
        else if(parsed < 1) { return "$WEIGHT minimum 1 oz"; } 
        return null;
        },
      onSaved: (value) => widget.post.weight = value,
    );  
  }

  Widget _quantityField(BuildContext context){
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
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
      onSaved: (value) => widget.post.quantity = int.parse(value),
    );
  }

  Widget _image(BuildContext context){
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2),
      child: Image.file(widget.post.image, fit: BoxFit.fitHeight,)
    );
  }

  Widget _form(BuildContext context){
    return Form(
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
    );
  }

  Widget _postButton(BuildContext context){
    return Builder(
      builder: (BuildContext context){
        return RaisedButton(
          child: Icon(Icons.cloud_upload),
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

  void _postImage() {
    final String fileName = '${DateTime.now()}.${p.basename(widget.post.image.path)}';
    StorageReference storageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageRef.putFile(
      widget.post.image,
      StorageMetadata(
        customMetadata: <String, String>{'activity': 'test'},
      )
    );
    Firestore.instance.collection(POSTS).add({
      FILENAME: fileName, 
      DESCRIPTION: widget.post.description,
      WEIGHT: widget.post.weight,
      QUANTITY: widget.post.quantity,
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
      body:SingleChildScrollView(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image(context),
            _form(context)
          ],
        )
      )
    );
  }
}