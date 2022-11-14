import 'package:flutter/material.dart';

import '../../config.dart';

List<String> timesList = <String>[
  "от 3 до 10 минут",
  "от 10 до 25 минут",
  "от 25 минут до 1 часа",
];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => DropdownButtonExampleState();
}

class DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = timesList.first;
  static DropdownButtonExampleState? current;

  void update() {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    current = this;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Config.darkModeOn ? Colors.black87 : Colors.white,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(
          color: Config.darkModeOn ? Colors.white : Colors.black87,
          fontFamily: "Montserrat",
          fontSize: 16
      ),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: timesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
              value,
          ),
          onTap: () {},
        );
      }).toList(),
    );
  }
}
