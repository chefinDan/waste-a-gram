import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waste_a_gram/screens/post_image_screen.dart';

class SelectImageScreen extends StatefulWidget{
  @override
  _SelectImageScreenState createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {

  void pushPostImageScreen(File image){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => PostImageScreen(image: image)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RaisedButton(
            child: Text('Select Photo'),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);
              if(image != null){
                pushPostImageScreen(image);
              }
            }
          ),
        ]
      )
    );
  }
}