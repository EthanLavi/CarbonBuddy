import 'dart:io';
import 'ingredient.dart';

class FoodRating {
  final SEASONAL_MOD = .90;

  List<Ingredient> ingredients = List.empty(growable: true);
  String grade = ''; // a letter grade
  double score = 1; // some value between 0 and 1
  List<String> suggestions = List.empty(growable: true);

  factory FoodRating(String data) {
    Sustainability sus = Sustainability.getInstance();
    return FoodRating.ing(sus.stringToIngredientList(data));
  }

  FoodRating.ing(this.ingredients) {
    int totalServings = 0;
    double totalImpact = 0;
    for (var i in ingredients) {
      totalServings += i.servings;
      double impact = i.servings *
          (i.local ? i.co2local : i.co2) *
          (i.seasonal ? SEASONAL_MOD : 1);
      totalImpact += impact;
    }
    score = (totalServings == 0 ? 0 : totalImpact / totalServings) / 24;
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
    if (score < .2) {
      suggestions.add(
          "Good job eating sustainably! Remember to minimize food waste by saving your leftovers.");
    } else if (score < .4) {
      suggestions.add(
          "Buying food locally is a great way to minimize the transportation emissions associated with you getting your food.");
    } else if (score < .6) {
      suggestions
          .add("Try some plant based subsitutes for meat and dairy products!");
    } else if (score < .8) {
      suggestions
          .add("Try eating foods with larger impacts in small portions.");
    } else {
      suggestions.add(
          "Eating sustainably overlaps with eating healthy! Prioritize fresh fruits and vegetables");
    }
  }
}

class Sustainability {
  final Map<String, Ingredient> _ingredients = {};
  static final Sustainability _instance = Sustainability._();

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
      'veggie',
      'misc'
    }) {
      _ingredients.addAll(_readCSV('$pathToAssets$fname.csv', fname));
    }
  }

  // Read a csv file and return a map of String->Ingredient
  _readCSV(String filename, String category) {
    Map<String, Ingredient> ingredients = {};
    final file = File(filename);
    List<String> lines = file.readAsLinesSync();
    try {
      for (var line in lines) {
        List<String> tokens = line.split(',');
        String iName = tokens.first;
        double ico2 = double.parse(tokens.elementAt(1));
        double ico2local = double.parse(tokens.last);
        Ingredient ingr = Ingredient(iName, ico2, ico2local, category);
        ingredients[iName] = ingr;
      }
    } catch (e) {
      print('Error: $e');
    }
    return ingredients;
  }

  // parse a string for words that appear in the csv files
  // and return a list of ingredient objects created
  stringToIngredientList(String data) {
    List<Ingredient> foodData = List.empty(growable: true);
    data = data.toLowerCase();
    List<String> tokens = data.split(RegExp('\\W'));

    for (int i = 0; i < tokens.length; i++) {
      String word = tokens[i];
      if (_ingredients.containsKey(word)) {
        foodData.add(_ingredients[word]!);
      }
    }
    return foodData;
  }
}
