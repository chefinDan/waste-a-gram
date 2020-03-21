import 'package:equatable/equatable.dart';
import 'package:waste_a_gram/models/post.dart';

abstract class FoodWasteState extends Equatable {
  const FoodWasteState();

  @override
  List<Object> get props => [];
}

class Loading extends FoodWasteState {}

class Empty extends FoodWasteState {}

class Loaded extends FoodWasteState {
  final List<Post> foodWasteEntries;

  Loaded(this.foodWasteEntries);

  @override
  List<Object> get props => [foodWasteEntries];
}

class Error extends FoodWasteState {
  final String error;

  Error(this.error);

  @override
  List<Object> get props => [error];
}
