# EatNeat

by Compiled with Warnings
Ben Schack, Ethan Lavi, Nathan Edmondson

## Project Vision

EatNeat is a mobile application that allows users to quickly see the carbon footprint of their food. Users can either take a photo of their food, a nutrition label, or just paste a recipe in and receive a grade on how sustainable they're eating. It will provide suggestions to help people be more conscientious in their future food choices. EatNeat leverages Google Cloud Vision and Flutter.

## Impact

EatNeat educates and empowers people to improve their eating habits. Food production is essential for our survival, but current practices are far from sustainable. Importantly, some foods (beef, dairy, etc.) have a significantly larger environmental impact that others. By presenting this information in the simple format of CO2 emissions, users of the app will be able to lower their impact from eating. People are faced with choices between different foods everyday at grocery stores, dining halls, and more. EatNeat is a simple but powerful tool to help concerned eaters make these choices with the information they need to work towards sustainability.

## Use Instructions

```bash
flutter run
```

Pick a device of your choice to run the app on.

### App Description

From the splash page, you can choose one of four options. You can take a picture of food, take a picture of a nutrition label, paste in a recipe, or input a dish name. When you choose to take a picture, you are moved to a camera UI screen. After taking a picture and clicking continue, you are asked to confirm if any ingredients were sourced locally. After confirming, you are given a score based on the impact of your ingredients. If you choose to paste a recipe, we give you a score based on the ingredients. When entering a dish name, we search for popular recipes, and give a score based on the ingredients.

Check out the general app flow [here](https://whimsical.com/flow-chart-Y9dgMHEdiKrmrwnXz2YJRJ)

## Future Plans

1. Monetization through advertizing certain local, sustainable food brands.
2. Grow our own datasets to better encompass the food market.
3. Use better (paid) APIs to get more accurate footprints of different foods

## Citations

1. <https://docs.flutter.dev/>
2. <https://morioh.com/p/fedbaa06bd1>
3. <https://docs.suggestic.com/graphql/>
4. <https://pub.dev/packages/graphql>
