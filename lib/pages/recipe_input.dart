import 'package:eat_neat/models/sustainability_query/sus.dart';
import 'package:flutter/material.dart';

class RecipeInputPage extends StatelessWidget {
  const RecipeInputPage({super.key});

  static TextEditingController recipeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Recipe Input", style: TextStyle(fontSize: 16)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(children: const [RecipeForm()]));
  }
}

// Define a custom Form widget.
class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final inputController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
            top: 0,
            bottom: 34,
            left: 10,
            right: 10,
            child: ListView(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                TextField(
                  controller: inputController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    //border: UnderlineInputBorder(),
                    labelText: 'Potato, tomato, avocado',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ]),
            ])),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FoodRating rating = FoodRating.string(inputController.text);
          Navigator.of(context).pushNamed("/recipe", arguments: rating);
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
