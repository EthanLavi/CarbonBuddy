import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  static const letterScore = "B";
  static const score = 0.85;

  static const ingredients = [
    ["Beef", 5],
    ["Pork", 3]
  ];

  static int sum = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
          top: 59,
          bottom: 34,
          left: 10,
          right: 10,
          child: ListView(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text("Your Emission Score",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                () {
                  if (score > 0.80) {
                    return const Text(letterScore,
                        style: TextStyle(fontSize: 36, color: Colors.green));
                  } else if (score < 0.60) {
                    return const Text(letterScore,
                        style: TextStyle(fontSize: 36, color: Colors.red));
                  } else {
                    return const Text(letterScore,
                        style: TextStyle(
                            fontSize: 36,
                            color: Color.fromARGB(255, 224, 207, 51)));
                  }
                }(),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(children: [
                        SizedBox(
                            width: (MediaQuery.of(context).size.width - 75) *
                                score),
                        const Text("${score * 100}%")
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
                              message:
                                  "Kilograms of carbon dioxide emitted while producing one serving of an ingredient",
                              child: Text("Kg of CO2",
                                  style: TextStyle(fontSize: 16))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: ingredients
                            .map((e) => Column(children: [
                                  Row(children: [
                                    Text(e[0].toString(),
                                        style: const TextStyle(fontSize: 15)),
                                    const Spacer(),
                                    Text(e[1].toString(),
                                        style: const TextStyle(fontSize: 15)),
                                  ]),
                                  const SizedBox(height: 5)
                                ]))
                            .toList(),
                      ),
                      const Divider(color: Color.fromARGB(150, 170, 170, 170)),
                      const SizedBox(height: 5),
                      Row(
                        children: const [
                          Text("Total", style: TextStyle(fontSize: 15)),
                          Spacer(),
                          Text("Sum goes here", style: TextStyle(fontSize: 15))
                        ],
                      )
                    ],
                  ))
            ],
          )),
    ]));
  }
}
