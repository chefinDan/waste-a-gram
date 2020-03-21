import 'package:equatable/equatable.dart';
import 'package:waste_a_gram/models/post.dart';

abstract class FoodWasteEvent extends Equatable {
  const FoodWasteEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodWaste extends FoodWasteEvent {}

class FoodWasteEntriesReceived extends FoodWasteEvent {
  final List<Post> foodWasteEntries;

  const FoodWasteEntriesReceived(this.foodWasteEntries);

  @override
  List<Object> get props => [foodWasteEntries];
}