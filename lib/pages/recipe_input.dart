import 'package:eat_neat/pages/home.dart';
import 'package:flutter/material.dart';

class RecipeInputPage extends StatelessWidget {
  const RecipeInputPage({super.key});

  static TextEditingController recipeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [const RecipeForm()]));
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
          top: 59,
          bottom: 34,
          left: 10,
          right: 10,
          child: ListView(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Text("Recipe Input", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
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
      Positioned(
          bottom: 34,
          left: 10,
          right: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go back'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      print(inputController.text);
                    },
                    child: const Text('Looks good!'),
                  ),
                ],
              )
            ],
          )),
    ]));
  }
}
