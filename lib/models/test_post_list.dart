import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_a_gram/components/food_waste_tile.dart';
import 'package:waste_a_gram/components/post_detail_card.dart';
import 'package:waste_a_gram/constants.dart';
import 'package:waste_a_gram/food_waste/food_waste_events.dart';
import 'package:waste_a_gram/food_waste/food_waste_state.dart';
import 'package:waste_a_gram/models/post.dart';
import 'package:waste_a_gram/respositories/food_waste_repository.dart';
import 'package:waste_a_gram/respositories/food_waste_repository_firestore.dart';

class PostList{
  final FoodWasteRepository _foodWasteRepository;
  StreamSubscription _foodWasteSubscription;
  // int _totalWaste; 

  PostList({
    @required FoodWasteRepository foodWasteRepository,
  }) : assert(foodWasteRepository != null),
       _foodWasteRepository = foodWasteRepository;


  Stream mapEventToState(FoodWasteEvent event) async* {
    if (event is LoadFoodWaste) {
      yield* _mapLoadFoodWasteToState();
    } else if (event is FoodWasteEntriesReceived) {
      yield* _mapFoodWasteUpdatesToState(event);
    }
  }

  Stream _mapLoadFoodWasteToState() async* {
    await _foodWasteSubscription?.cancel();
    _foodWasteSubscription =
        _foodWasteRepository.posts().listen(
              (posts) => FoodWasteEntriesReceived(posts),
        );
  }

  Stream _mapFoodWasteUpdatesToState(
    FoodWasteEntriesReceived event,
  ) async* {
    if (event.foodWasteEntries.isEmpty) {
      yield Empty();
    } else {
      yield Loaded(event.foodWasteEntries);
    }
  }

}

class Test{

  final PostList _postList = PostList(foodWasteRepository: FoodWasteRepositoryFirestore());

}