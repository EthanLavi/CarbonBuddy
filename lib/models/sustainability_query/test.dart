import 'package:eat_neat/models/sustainability_query/sus.dart';

void main() {
  // Sustainability s = Sustainability.getInstance();
  // print(s);
  String test1 = "chicken rice broccoli kale spinach apple";
  String test2 = "beef pork butter";
  String test3 = "apple carrot cheese";
  test(test1);
  test(test2);
  test(test3);
}

void test(String s) {
  print('rating for: $s');
  FoodRating fr = FoodRating(s);
  double score = fr.score;
  String grade = fr.grade;
  String su = fr.suggestions.first;
  print('score: $score\tgrade:$grade\tsuggests:$su');
}
