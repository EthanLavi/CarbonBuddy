import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueGrey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
          top: 59,
          bottom: 34,
          left: 10,
          right: 10,
          child: Wrap(children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Ingredients",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
                  ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.topRight,
                      child: Tooltip(
                        waitDuration: Duration(milliseconds: 500),
                        message: "Is this food sourced locally?",
                        child: Icon(
                          Icons.info,
                          size: 15,
                        ),
                      ))
                ]),
            /*() {
              // Meat and Eggs section
              var inRecipe = true;

              List<String> items = ["Steak", "Chicken"];

              if (inRecipe) {
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(items[index]);
                    });
              }
            }(),*/
            () {
              // Dairy
              var inRecipe = true;

              if (inRecipe) {
                return Column(children: [
                  const SizedBox(height: 7),
                  Row(children: const [
                    Text("Dairy", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    MyStatefulWidget()
                  ]),
                  const SizedBox(height: 5),
                  const Divider(color: Color.fromARGB(150, 170, 170, 170))
                ]);
              }
            }(),
            () {
              // Seafood
              var inRecipe = true;

              if (inRecipe) {
                return Column(children: [
                  const SizedBox(height: 7),
                  Row(children: const [
                    Text("Seafood", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    MyStatefulWidget()
                  ]),
                  const SizedBox(height: 5),
                  const Divider(color: Color.fromARGB(150, 170, 170, 170))
                ]);
              }
            }(),
            () {
              // Produce
              var inRecipe = true;

              if (inRecipe) {
                return Column(children: [
                  const SizedBox(height: 7),
                  Row(children: const [
                    Text("Produce", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    MyStatefulWidget()
                  ]),
                  const SizedBox(height: 5),
                  const Divider(color: Color.fromARGB(150, 170, 170, 170))
                ]);
              }
            }(),
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
                  const Text("Servings: ", style: TextStyle(fontSize: 18)),
                  /*TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  )*/
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {},
                    child: const Text('Go back'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {},
                    child: const Text('Looks good!'),
                  ),
                ],
              )
            ],
          )),
    ]));
  }
}
