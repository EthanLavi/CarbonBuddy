import 'dart:convert';
import 'dart:io';
import 'ingredient.dart';

class FoodRating {
  final SEASONAL_MOD = .90;

  List<Ingredient> ingredients = List.empty();
  String grade = ""; // a letter grade
  double score = 1; // some value between 0 and 1
  List<String> suggestions = List.empty();

  FoodRating(String data) {
    Sustainability sus = Sustainability.getInstance();
    FoodRating.ing(sus.stringToIngredientList(data));
  }

  FoodRating.ing(List<Ingredient> ingredients) {
    this.ingredients = ingredients;
    int totalServings = 0;
    double totalImpact = 0;
    for (var i in ingredients) {
      totalServings += i.servings;
      double impact = i.servings *
          (i.local ? i.co2local : i.co2) *
          (i.seasonal ? SEASONAL_MOD : 1);
      totalImpact += impact;
    }
    score = (totalServings == 0 ? 0 : totalImpact / totalServings);
    _assignGrade();
    _assignSuggestions();
  }

  _assignGrade() {
    if (score < .2) {
      grade = 'A';
    } else if (score < .4) {
      grade = 'B';
    } else if (score < .6) {
      grade = 'C';
    } else if (score < .8) {
      grade = 'D';
    } else {
      grade = 'F';
    }
  }

  _assignSuggestions() {
    suggestions.add(
        "Way to eat! I hope someone adds some nice suggestions to help you eat more sustainably");
  }
}

class Sustainability {
  Map<String, Ingredient> _ingredients = Map();
  static Sustainability _instance = Sustainability._();

  static getInstance() {
    return _instance;
  }

  // initialize the ingredient list
  Sustainability._() {
    _readAllCSV();
  }

  // read all of our csv files and store into _ingredients
  _readAllCSV() {
    String pathToAssets = "../../../assets/";
    for (var fname in {
      'dairy',
      'fruit',
      'grain',
      'meatEggs',
      'seafood',
      'veggie'
    }) {
      _ingredients.addAll(_readCSV('$pathToAssets$fname.csv', fname));
    }
  }

  // Read a csv file and return a map of String->Ingredient
  _readCSV(String filename, String category) async {
    Map<String, Ingredient> ingredients = Map();
    final file = File(filename);
    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(LineSplitter()); // Convert stream to individual lines.
    try {
      await for (var line in lines) {
        List<String> tokens = line.split(',');
        String iName = tokens.first;
        double ico2 = double.parse(tokens.elementAt(1));
        double ico2local = double.parse(tokens.last);
        Ingredient ingr = Ingredient(iName, ico2, ico2local, category);
        ingredients[iName] = ingr;
      }
      return ingredients;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  // parse a string for words that appear in the csv files
  // and return a list of ingredient objects created
  stringToIngredientList(String data) {
    List<Ingredient> foodData = List.empty();
    data = data.toLowerCase();
    List<String> tokens = data.split(RegExp('\W'));

    for (int i = 0; i < tokens.length; i++) {
      String word = tokens[i];
      if (_ingredients.containsKey(word)) {
        foodData.add(_ingredients[word]!);
      }
    }
    return foodData;
  }
}
