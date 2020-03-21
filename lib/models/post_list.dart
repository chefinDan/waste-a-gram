import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_a_gram/components/food_waste_tile.dart';
import 'package:waste_a_gram/components/post_detail_card.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/models/post.dart';

class PostList{
  final List<Post> _data;
  final Stream<QuerySnapshot> _stream;
  int _totalWaste; 

  PostList.fromStream(Stream<QuerySnapshot> stream) : 
    _data = List<Post>(),
    _stream = stream,
    _totalWaste = 0;
  
  void listen(Function setState) {
    _stream.listen(
      (QuerySnapshot snapshot) {
        snapshot.documents.where(
          (DocumentSnapshot docSnapshot) {
            if(this.contains(snapshot: docSnapshot)){
              this.update(snapshot: docSnapshot);
              return false;
            }
            return true;
          }
        ).forEach(
          (DocumentSnapshot snapshot) => this.add(snapshot: snapshot)
        );
        _totalWaste = _data.fold(0, (prev, curr) => prev + curr.quantity);
        setState();
      }
    ).asFuture((_) {
      print('== DONE');
    });
  } 

  bool contains({DocumentSnapshot snapshot, Post foodWasteData}){
    if(_data.isEmpty){
      return false;
    }
    return _data.any((Post curr) {
      return (snapshot != null) ?
        curr.id == snapshot.documentID :
        curr.id == foodWasteData.id;
    });
  }

  void update({DocumentSnapshot snapshot, Post foodWasteData}){
    _data.firstWhere((Post foodWasteData) => foodWasteData.id == snapshot.documentID)
    .imageUrl = snapshot[IMAGE_URL];
  }


  List<Post> add({Post foodWaste, List<Post> foodWastes, DocumentSnapshot snapshot}){
    assert(foodWaste != null || foodWastes != null || snapshot != null);
    if(foodWaste != null){
      _data.add(foodWaste);
    }
    else if(foodWastes != null){
      _data.addAll(foodWastes);
    }
    else{
      _data.add(Post.fromSnapshot(snapshot));
    }
    return _data;
  }


  int get totalWaste => _data.fold(0, (prev, curr) => prev+curr.quantity);


  Widget build(Future<Uint8List> tappedImageData, {Function onTapped, Function onDelete}){
    return (_data.isEmpty) ? 
    Center(child: CircularProgressIndicator()) :
    
    ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: _data.length,
      itemBuilder: (BuildContext context, index){
        return _data[index].detailView == true ?
          PostDetailCard(
            post: _data[index],
            imageStream: tappedImageData.asStream(),
            onTapped: (){
               _data[index].detailView = true;
            }
          ) : 
          FoodWasteTile(
            postData: _data[index],
            onDelete: () {
              onDelete(_data[index]);
              _data.remove(_data[index]);
            },
            onTapped: () {
              onTapped(_data[index]);
              _data[index].detailView = true;
            },
        );
      }
    );
  }
}