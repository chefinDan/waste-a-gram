import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:waste_a_gram/constants.dart';


class Camera extends StatefulWidget{

  Camera();

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  File image;

  void getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future postImage() async {
    StorageReference storageRef = FirebaseStorage.instance.ref().child('${DateTime.now()}.${p.basename(image.path)}');
    StorageUploadTask uploadTask = storageRef.putFile(image);
    // uploadImage(uploadTask);
    await uploadTask.onComplete;
    final imageUrl = await storageRef.getDownloadURL();
    print(imageUrl);
    Firestore.instance.collection(POSTS).add({
      WEIGHT: '22',
      SUBMISSION_DATE: DateTime.now(),
      IMAGE_URL: imageUrl
    });
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
            onPressed: () async { 
              await postImage();
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