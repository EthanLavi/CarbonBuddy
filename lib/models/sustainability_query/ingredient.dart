class Ingredient {
  String name = "", cataegory = "";
  double co2 = 0, co2local = 0;
  bool local = false, seasonal = false;

  Ingredient(String name, double co2, double co2local) {
    this.name = name;
    this.co2 = co2;
    this.co2local = co2local;
  }
}
