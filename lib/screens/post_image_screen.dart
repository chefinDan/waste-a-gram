import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:waste_a_gram/constants.dart';

class PostPhotoDto{
  String description;
  String weight;
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

  Widget _descriptionTextField(BuildContext context){
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Description', border: OutlineInputBorder()
      ),
      validator: (value) { if(value.isEmpty) {return "Title cannot be empty"; } return null; },
      onSaved: (value) => _postPhotoDto.description = value
    );
  }

  Widget _weightField(BuildContext context){
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Weight', border: OutlineInputBorder()
      ),
      validator: (value) { 
        if(value.isEmpty) { return "Weight cannot be empty"; }
        if(int.tryParse(value) == null) { return "Weight must be an integer number"; } 
        return null;
        },
      onSaved: (value) => _postPhotoDto.weight = value,
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

  Future _postImage() async {
    StorageReference storageRef = FirebaseStorage.instance.ref().child('${DateTime.now()}.${p.basename(widget.image.path)}');
    StorageUploadTask uploadTask = storageRef.putFile(widget.image);
    await uploadTask.onComplete;
    final imageUrl = await storageRef.getDownloadURL();
    Firestore.instance.collection(POSTS).add({
      DESCRIPTION: _postPhotoDto.description,
      WEIGHT: _postPhotoDto.weight,
      SUBMISSION_DATE: DateTime.now(),
      IMAGE_URL: imageUrl
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _postPhotoForm(context)
    );
  }
}