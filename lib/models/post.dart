import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_a_gram/constants.dart';

class Post {
  String description;
  String filename;
  String imageUrl;
  GeoPoint location;
  int quantity;
  Timestamp submissionDate;
  String weight;
  File image;
  bool detailView;
  DocumentReference snapshotReference;
  String id;

  Post({
    this.id,
    this.description,
    this.filename,
    this.imageUrl,
    this.location,
    this.quantity,
    this.submissionDate,
    this.weight,
    this.image,
    this.detailView = false
  });

  Post.fromSnapshot(DocumentSnapshot snapshot){
    this.description = snapshot[DESCRIPTION];
    this.filename = snapshot[FILENAME];
    this.imageUrl = snapshot[IMAGE_URL];
    this.location = snapshot[LOCATION];
    this.quantity = snapshot[QUANTITY];
    this.submissionDate = snapshot[SUBMISSION_DATE];
    this.weight = snapshot[WEIGHT];
    this.detailView = false;
    this.snapshotReference = snapshot.reference;
    this.id = snapshot.documentID;
  }

  bool equals({DocumentSnapshot snapshot, Post foodWasteData}){
    if(snapshot != null){
      return (
        this.description == snapshot[DESCRIPTION] &&
        this.filename == snapshot[FILENAME] &&
        this.imageUrl == snapshot[IMAGE_URL] &&
        this.quantity == snapshot[QUANTITY] &&
        this.weight == snapshot[WEIGHT] &&
        this.id == snapshot.documentID
      );
    }
    return foodWasteData == this;
  }

  bool isUpdated(DocumentSnapshot snapshot){  
      return (
        this.description == snapshot[DESCRIPTION] &&
        this.filename == snapshot[FILENAME] &&
        this.imageUrl == snapshot[IMAGE_URL] &&
        this.quantity == snapshot[QUANTITY] &&
        this.weight == snapshot[WEIGHT]
      );
  }

  void printData(){
    print('\n===============================');
    print('$DESCRIPTION: $description');
    print('$FILENAME: $filename');
    print('$IMAGE_URL: $imageUrl');
    print('$LOCATION: $location');
    print('$QUANTITY: $quantity');
    print('$SUBMISSION_DATE: $submissionDate');
    print('$WEIGHT: $weight');
    print('$DETAIL_VIEW: $detailView');
    print('snapshotReference: ${snapshotReference.toString()}');
    print('id: $id');
    print('=================================');
  }
}