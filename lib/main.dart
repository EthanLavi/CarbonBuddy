import 'package:eat_neat/pages/dish_input.dart';
import 'package:eat_neat/pages/home.dart';
import 'package:eat_neat/pages/infer_image.dart';
import 'package:eat_neat/pages/load_image.dart';
import 'package:eat_neat/pages/recipe.dart';
import 'package:eat_neat/pages/recipe_input.dart';
import 'package:eat_neat/pages/score.dart';
import 'package:flutter/material.dart';
import 'models/helper/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CarbonBuddy());
}

class CarbonBuddy extends StatelessWidget {
  const CarbonBuddy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus when we click away
        // Mainly added so we can dismiss keyboard by clicking something else
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hide debug banner
        title: 'EatNeat', // Title of the app
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffF4F4F4), // background color
          colorScheme: ColorScheme.fromSeed(
              seedColor:
                  ColorThemes.secondayColor), // create default color scheme
          fontFamily: 'Lato', // set font
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashHome(),
          '/image': (context) => const QueryPhoto(),
          '/recipe': (context) => const Placeholder(),
          '/image/infer': (context) => const InferencePage(),
          '/score': (context) => const ScorePage(),
          '/recipe/input': (context) => const RecipeInputPage(),
          '/dish/input': (context) => const DishInputPage(),
        },
      ),
    );
  }
}
