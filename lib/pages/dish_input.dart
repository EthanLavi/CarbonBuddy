import 'package:eat_neat/models/sustainability_query/sus.dart';
import 'package:flutter/material.dart';

class DishInputPage extends StatelessWidget {
  const DishInputPage({super.key});

  static TextEditingController recipeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Dish Input", style: TextStyle(fontSize: 16)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(children: const [DishForm()]));
  }
}

// Define a custom Form widget.
class DishForm extends StatefulWidget {
  const DishForm({super.key});

  @override
  State<DishForm> createState() => _DishFormState();
}

class _DishFormState extends State<DishForm> {
  final inputController = TextEditingController();

  bool stopper = true;

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
                  maxLines: 1,
                  decoration: const InputDecoration(
                    //border: UnderlineInputBorder(),
                    labelText: 'Menemen',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ]),
            ]))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (stopper) {
            stopper = false;
            NavigatorState state = Navigator.of(context);
            FoodRating rating = await FoodRating.getRatingFromDishName(inputController.text);
            state.pushNamed("/recipe", arguments: rating);
            stopper = true;
          }
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
