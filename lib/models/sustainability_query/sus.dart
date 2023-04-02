// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pluralize/pluralize.dart';

import 'ingredient.dart';
import 'quiz.dart';
import 'recipes.dart';

class FoodRating {
  final SEASONAL_MOD = .90;
  final ALL_FOOD_DIVIDE = 12;

  Set<Ingredient> ingredients = {};
  String grade = ''; // a letter grade
  double score = 1; // some value between 0 and 1
  double total = 0; // total co2 value
  List<String> suggestions = List.empty(growable: true);

  factory FoodRating.string(String data) {
    Sustainability sus = Sustainability.getInstance();
    return FoodRating.ing(sus.stringToIngredientList(data));
  }

  // this is probably the one you'll want to use. Checks for recipe names
  static Future<FoodRating> getRatingFromList(List<String> data) async {
    Sustainability sus = Sustainability.getInstance();
    for (var str in data) {
      if (sus.isRecipe(str.toLowerCase())) {
        return FoodRating.listMulti(await getIngredientListFromID(await recipeSearch(str)));
      }
    }
    return FoodRating.ing(sus.stringListToIngredientList(data));
  }

  // this is probably the one you'll want to use. Checks for recipe names
  static Future<FoodRating> getRatingFromDishName(String data) async {
    Sustainability sus = Sustainability.getInstance();
    return FoodRating.listMulti(await getIngredientListFromID(await recipeSearch(data)));
  }

  factory FoodRating.listMulti(List<Object?> data) {
    Sustainability sus = Sustainability.getInstance();
    return FoodRating.ing(sus.stringListListToIngredientList(data));
  }

  FoodRating.ing(this.ingredients) {
    int totalServings = 0;
    for (var i in ingredients) {
      totalServings += i.servings;
      double impact = i.servings * (i.local ? i.co2local : i.co2) * (i.seasonal ? SEASONAL_MOD : 1);
      total += impact;
    }
    score = (totalServings == 0 ? 0 : total / totalServings) / ALL_FOOD_DIVIDE;
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
      suggestions.add("Good job eating sustainably! Remember to minimize food waste by saving your leftovers.");
    } else if (score < .4) {
      suggestions.add("Buying food locally is a great way to minimize the transportation emissions associated with you getting your food.");
    } else if (score < .6) {
      suggestions.add("Try some plant based subsitutes for meat and dairy products!");
    } else if (score < .8) {
      suggestions.add("Try eating foods with larger impacts in small portions.");
    } else {
      suggestions.add("Eating sustainably overlaps with eating healthy! Prioritize fresh fruits and vegetables");
    }
  }
}

class Sustainability {
  final Map<String, Ingredient> _ingredients = {};
  final Set<String> _recipes = {};
  static final Sustainability _instance = Sustainability._();

  static getInstance() {
    return _instance;
  }

  // initialize the ingredient list
  Sustainability._();

  Future<void> init() async {
    await _readAllCSV();
    await _readRecipes();
  }

  Future<void> _readRecipes() async {
    final file = await rootBundle.loadString("assets/dishes.txt");
    List<String> lines = file.split(RegExp("\n"));
    try {
      for (var line in lines) {
        if (line == "") continue;
        _recipes.add(line.replaceAll(RegExp("\n"), ""));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // read all of our csv files and store into _ingredients
  Future<void> _readAllCSV() async {
    String pathToAssets = "assets/";
    Map<String, String> nameMapper = {
      'dairy': 'Dairy Products',
      'fruit': 'Fruit',
      'grain': 'Grain & Legumes',
      'meat': 'Meat & Eggs',
      'seafood': 'Seafood',
      'vegetable': 'Produce',
      'misc': 'Miscellaneous',
    };
    for (var fname in {'dairy', 'fruit', 'grain', 'meat', 'seafood', 'vegetable', 'misc'}) {
      _ingredients.addAll(await _readCSV('$pathToAssets$fname.csv', nameMapper[fname] ?? 'Miscellaneous'));
    }
  }

  // Read a csv file and return a map of String->Ingredient
  Future<Map<String, Ingredient>> _readCSV(String filename, String category) async {
    Map<String, Ingredient> ingredients = {};
    final file = await rootBundle.loadString(filename);
    List<String> lines = file.split(RegExp("\n"));
    try {
      for (var line in lines) {
        if (line == "") continue;
        List<String> tokens = line.split(',');
        String iName = tokens.first;
        double ico2local = double.parse(tokens.elementAt(1));
        double ico2 = double.parse(tokens.last);
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
    Set<Ingredient> foodData = {};
    data = data.toLowerCase();
    List<String> tokens = data.split(RegExp('\\W'));
    for (int i = 0; i < tokens.length; i++) {
      String word = Pluralize().singular(tokens[i]);
      if (_ingredients.containsKey(word)) {
        Ingredient i = _ingredients[word]!;
        foodData.add(i);
      }
    }

    return foodData;
  }

  // parse a string for words that appear in the csv files
  // and return a list of ingredient objects created
  stringListToIngredientList(List<String> data) {
    Set<Ingredient> foodData = {};

    for (int i = 0; i < data.length; i++) {
      String word = Pluralize().singular(data[i].toLowerCase());
      if (_ingredients.containsKey(word)) {
        Ingredient i = _ingredients[word]!;
        foodData.add(i);
      }
    }

    return foodData;
  }

  stringListListToIngredientList(List<Object?> data) {
    Set<Ingredient> foodData = {};

    for (int i = 0; i < data.length; i++) {
      String word;
      if (data[i].runtimeType == String) {
        word = data[i] as String;
      } else {
        continue;
      }

      word = word.toLowerCase();
      List<String> tokens = word.split(RegExp('\\W'));

      for (int j = 0; j < tokens.length; j++) {
        String word = Pluralize().singular(tokens[j]);
        if (_ingredients.containsKey(word)) {
          Ingredient i = _ingredients[word]!;
          foodData.add(i);
        }
      }
    }

    return foodData;
  }

  // takes a list of strings that are either ingredients
  // or categories, and returns a list of question objects
  generateQuestions(List<String> data) {
    List<Question> questions = List.empty(growable: true);

    Map<String, Category> categories = {
      'meat': Category('meat'),
      'grain': Category('grain'),
      'seafood': Category('seafood'),
      'vegetable': Category('vegetable'),
      'fruit': Category('fruit'),
      'dairy': Category('dairy')
    };

    for (int i = 0; i < data.length; i++) {
      String word = data[i];
      if (_ingredients.containsKey(word)) {
        Ingredient i = _ingredients[word]!;
        categories[i.category]!.instanceof = true;
        categories[i.category]!.ingredients.add(i);
      }
      if (categories.containsKey(word)) {
        categories[word]!.mentioned = true;
      }
    }

    for (var cat in categories.values) {
      if (cat.mentioned && !cat.instanceof) {
        questions.add(Question(cat));
      }
    }
    return questions;
  }

  isRecipe(String word) {
    return _recipes.contains(word);
  }
}
