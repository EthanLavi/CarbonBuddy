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
  String text = "", catName = "";
  late List<Ingredient> options;

  Question(Category c) {
    catName = c.name;
    text = 'We detected a $catName, please help us find a specific food.';
    options = c.ingredients;
  }
}

class Answer {
  String catName = "";
  String ingName = "";
  Answer(this.catName, this.ingName);

  // use an answer to clarify the ingredients list
  applyAnswer(List<String> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i] == catName) {
        data[i] = ingName;
      }
    }
  }
}
