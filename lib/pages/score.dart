import 'package:eat_neat/models/sustainability_query/ingredient.dart';
import 'package:eat_neat/models/sustainability_query/sus.dart';
import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    FoodRating? rating;
    if (ModalRoute.of(context)!.settings.arguments != null && rating == null) rating = ModalRoute.of(context)!.settings.arguments as FoodRating;
    if (rating == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Ingredients"), backgroundColor: Colors.blueGrey),
      );
    }

    String letterScore = rating.grade;
    double score = 1 - rating.score;
    List<Ingredient> ingredients = rating.ingredients.toList();
    double sum = rating.total;

    return Scaffold(
        appBar: AppBar(title: const Text("Emission Score"), backgroundColor: Colors.blueGrey),
        body: Stack(children: [
          Positioned(
              top: 59,
              bottom: 34,
              left: 10,
              right: 10,
              child: ListView(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Text("Your Emission Score", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    () {
                      if (score > 0.80) {
                        return Text(letterScore, style: const TextStyle(fontSize: 36, color: Colors.green));
                      } else if (score < 0.60) {
                        return Text(letterScore, style: const TextStyle(fontSize: 36, color: Colors.red));
                      } else {
                        return Text(letterScore, style: const TextStyle(fontSize: 36, color: Color.fromARGB(255, 224, 207, 51)));
                      }
                    }(),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(children: [
                          Row(children: [
                            SizedBox(width: ((MediaQuery.of(context).size.width - 100) * score).clamp(0, MediaQuery.of(context).size.width - 100)),
                            Text("${(score * 100).clamp(0, 100).toStringAsFixed(2)}%"),
                          ]),
                          Container(
                              height: 3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Colors.red,
                                    Colors.green,
                                  ]))),
                        ])),
                  ]),
                  const SizedBox(height: 25),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text("Ingredients", style: TextStyle(fontSize: 16)),
                              Spacer(),
                              Tooltip(
                                  waitDuration: Duration(milliseconds: 500),
                                  message: "Kilograms of carbon dioxide emitted while producing one serving of an ingredient",
                                  child: Text("Kg of CO2", style: TextStyle(fontSize: 16))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: ingredients
                                .map((e) => Column(children: [
                                      Row(children: [
                                        Text(e.name.toString(), style: const TextStyle(fontSize: 15)),
                                        const Spacer(),
                                        Text((e.local ? e.co2local : e.co2).toString(), style: const TextStyle(fontSize: 15)),
                                      ]),
                                      const SizedBox(height: 5)
                                    ]))
                                .toList(),
                          ),
                          const Divider(color: Color.fromARGB(150, 170, 170, 170)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text("Total", style: TextStyle(fontSize: 15)),
                              const Spacer(),
                              Text(sum.toStringAsFixed(2), style: const TextStyle(fontSize: 15))
                            ],
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      rating.suggestions.first,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              )),
        ]));
  }
}
