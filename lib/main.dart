import 'package:eat_neat/pages/home.dart';
import 'package:eat_neat/pages/load_image.dart';
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
        title: 'Carbon Buddy', // Title of the app
        theme: ThemeData(
          scaffoldBackgroundColor: ColorThemes.lightPrimaryColor, // background color
          colorScheme: ColorScheme.fromSeed(seedColor: ColorThemes.secondayColor), // create default color scheme
          fontFamily: 'Lato', // set font
        ),
        initialRoute: '/', // starting route for navigation. starting at /auth because we are pretending we are authenticated
        routes: {
          '/': (context) => const SplashHome(),
          '/image': (context) => const QueryPhoto(), // After-auth page is the message board
        },
      ),
    );
  }
}
