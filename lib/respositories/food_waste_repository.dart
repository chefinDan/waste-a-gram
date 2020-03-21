import 'package:waste_a_gram/models/post.dart';

abstract class FoodWasteRepository {
  Stream<List<Post>> posts();
}