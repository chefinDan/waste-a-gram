import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waste_a_gram/screens/upload_image_screen.dart';

class SelectImageScreen extends StatelessWidget{

  Widget _selectImageButton(BuildContext context){
    return RaisedButton(
      child: Text('Select Photo'),
      onPressed: () async {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        if(image != null){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => UploadImageScreen(image: image)
          ));
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _selectImageButton(context)
        ]
      )
    );
  }
}