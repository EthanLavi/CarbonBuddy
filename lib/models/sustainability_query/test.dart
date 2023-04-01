import 'package:eat_neat/models/sustainability_query/quiz.dart';
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

  List<String> test4 = ["pork", "rice", "meat", "fruit", "grain", "dairy"];
  List<String> test5 = ["meat", "beef", "onion", "potato"];
  testl(test4);
  testl(test5);
}

void test(String s) {
  print('rating for: $s');
  FoodRating fr = FoodRating.string(s);
  double score = fr.score;
  String grade = fr.grade;
  String su = fr.suggestions.first;
  print('score: $score\tgrade:$grade\tsuggests:$su');
}

void testl(List<String> s) {
  print('rating for: $s');
  Sustainability sus = Sustainability.getInstance();

  List<Question> qs = sus.generateQuestions(s);
  print(qs.length);

  FoodRating fr = FoodRating.list(s);
  double score = fr.score;
  String grade = fr.grade;
  String su = fr.suggestions.first;
  print('score: $score\tgrade:$grade\tsuggests:$su');
}
