class Ingredient {
  String name = "", category = "";
  double co2 = 0, co2local = 0;
  bool local = false, seasonal = false;
  int servings = 1;

  Ingredient(String name, double co2, double co2local, String category) {
    this.name = name;
    this.co2 = co2;
    this.co2local = co2local;
    this.category = category;
  }

  @override
  String toString() {
    return '$name  CO2 emmisions: $co2:$co2local\tcategory:$category';
  }
}
