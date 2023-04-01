import 'package:eat_neat/models/sustainability_query/ingredient.dart';

class Category {
  String name = "";
  // mentioned means the generic name was used
  // instanceof means the specific name was used
  bool mentioned = false, instanceof = false;
  List<Ingredient> ingredients = List.empty(growable: true);
  Category(this.name);
}

class Question {
  String text = "";
  late List<Ingredient> options;

  Question(Category c) {
    String name = c.name;
    text = 'We detected a $name, please help us find a specific food.';
    options = c.ingredients;
  }
}
