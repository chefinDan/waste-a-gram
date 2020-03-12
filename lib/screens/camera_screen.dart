import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget{
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  
  File image;
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (content, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                var post = snapshot.data.documents[index];
                return ListTile(
                  leading: Text(post['weight'].toString()),
                  title: Text('Post Title'),
                );
              }
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}