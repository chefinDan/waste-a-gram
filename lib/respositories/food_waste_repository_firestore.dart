import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/models/post.dart';
import 'package:waste_a_gram/respositories/food_waste_repository.dart';

class FoodWasteRepositoryFirestore implements FoodWasteRepository {
  final postQuery = Firestore.instance
    .collection(POSTS)
    .orderBy(SUBMISSION_DATE, descending: true);

  @override
  Stream<List<Post>> posts(){
    return postQuery.snapshots()
      .map((QuerySnapshot snapshot) => snapshot.documents
        .map((DocumentSnapshot document) => Post.fromSnapshot(document))
        .toList());
  } 
}