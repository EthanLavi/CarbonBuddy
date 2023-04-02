class Ingredient {
  String name = "", category = "";
  double co2 = 0, co2local = 0;
  bool local = false, seasonal = false;
  int servings = 1;

  Ingredient(this.name, this.co2, this.co2local, this.category);

  @override
  String toString() {
    return '$name  CO2 emmisions: $co2:$co2local\tcategory:$category';
  }
}

