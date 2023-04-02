import 'package:eat_neat/models/sustainability_query/ingredient.dart';
import 'package:eat_neat/models/sustainability_query/sus.dart';
import 'package:flutter/material.dart';

class LocalSourcedPage extends StatefulWidget {
  const LocalSourcedPage({super.key});

  @override
  State<LocalSourcedPage> createState() => _LocalSourcedPageState();
}

class _LocalSourcedPageState extends State<LocalSourcedPage> {
  FoodRating? rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null && rating == null) rating = ModalRoute.of(context)!.settings.arguments as FoodRating;
    if (rating == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Ingredients"), backgroundColor: Colors.blueGrey),
      );
    }

    List<Ingredient> ingredients = rating!.ingredients.toList();

    ingredients.sort((Ingredient i1, Ingredient i2) => i1.category.compareTo(i2.category));

    String lastCategory = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredients"),
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.settings.name != "/image/infer" && route.settings.name != "/recipe");
          },
        ),
      ),
      body: Stack(children: [
        Positioned(
          top: 16,
          bottom: 40,
          left: 24,
          right: 24,
          child: ListView(
            children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Locally\nSourced",
                        style: TextStyle(fontWeight: FontWeight.w400, color: Color.fromARGB(255, 108, 108, 108), fontSize: 22),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ] +
                ingredients.expand<Widget>((e) sync* {
                  if (e.category != lastCategory) {
                    lastCategory = e.category;
                    yield const Divider();
                    yield Text(
                      e.category,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 66, 66, 66)),
                    );
                  }
                  yield Dismissible(
                    onDismissed: (DismissDirection direction) {
                      ingredients.remove(e);
                      setState(() {});
                    },
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart, // limit swipe-to-delete direction
                    background: Container(
                      // red container behind the dismissible
                      color: Colors.red,
                      child: Row(
                        children: const [
                          // Delete icon in the background
                          Expanded(child: SizedBox()),
                          Icon(Icons.delete, color: Colors.white, size: 32),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Color.fromARGB(255, 108, 108, 108)),
                        ),
                        Checkbox(
                            value: e.local,
                            onChanged: (bool? newValue) {
                              setState(() {
                                e.local = newValue!;
                              });
                            })
                      ],
                    ),
                  );
                }).toList(), // + list
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FoodRating ratingNew = FoodRating.ing(ingredients.toSet());
          Navigator.of(context).pushNamed("/score", arguments: ratingNew);
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
