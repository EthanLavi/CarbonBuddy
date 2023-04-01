import 'dart:convert';
import 'dart:io';
import 'ingredient.dart';

class Sustainibility {
  Map<String, Ingredient> _ingredients = new Map();

  // initialize the ingredient list
  Sustainibility() {
    _readAllCSV();
  }

  // read all of our csv files and store into _ingredients
  _readAllCSV() {
    String pathToAssets = "../../../assets/";
    for (var fname in {
      'dairy.csv',
      'fruit.csv',
      'grain.csv',
      'meatEggs.csv',
      'seafood.csv',
      'veggie.csv'
    }) {
      _ingredients.addAll(_readCSV(pathToAssets + fname));
    }
  }

  // Read a csv file and return a map of String->Ingredient
  _readCSV(String filename) async {
    Map<String, Ingredient> ingredients = new Map();
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
        Ingredient ingr = new Ingredient(iName, ico2, ico2local);
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
  stringToIngredientList(String data) {}
}
