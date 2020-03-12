import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waste_a_gram/constants.dart';

class Camera extends StatefulWidget{

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  File image;

  void getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Widget selectPhotoPrompt() { 
    return Center(
      child: RaisedButton(
        child: Text('Select Photo'),
        onPressed: getImage
      ) 
    );
  }

  Widget postPhotoForm(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
            child: Image.file(image)),
          SizedBox(height: 40,),
          RaisedButton(
            child: Text('Post'),
            onPressed: () { 
              Firestore.instance.collection(POSTS).add({
                WEIGHT: '22',
                SUBMISSION_DATE: DateTime.now()
              });
              Navigator.of(context).pop();
          })
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: (image == null) ? selectPhotoPrompt(): postPhotoForm(context)
    );
  }
}