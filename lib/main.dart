import 'dart:developer';

import 'package:flutter/material.dart';

import 'recipe_header.dart';

void handle() {
  print("Button has pressed");
}

void main() {
  runApp(VoiceRecipe());
}

class VoiceRecipe extends StatelessWidget {
  final List<RecipeHeader> recipes = [
    RecipeHeader(name: "Борщ", imageUrl: "assets/images/borsh.png", id: 0),
    RecipeHeader(
        name: "Карбонара", imageUrl: "assets/images/carbonara.png", id: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("VoiceRecipe"),
          centerTitle: true,
          // backgroundColor: Colors.amberAccent,
        ),
        body: Container(
          color: Colors.orangeAccent,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: recipes.length,
            itemBuilder: (_, index) => Card(
                elevation: 40,
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  hoverColor: Colors.black12,
                  dense: false,
                  title: Text(
                    recipes[index].name,
                    style: const TextStyle(
                        fontSize: 32,
                        fontFamily: "Montserrat",
                        color: Colors.black87),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image(
                    image: AssetImage(recipes[index].imageUrl),
                  ),
                  onTap: () => print("${recipes[index].id} on tap"),
                )),
          ),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: handle,
          child: Text("add"),
        ),
      ),
      theme: ThemeData(primarySwatch: Colors.orange),
    );
  }
}

/*
ListTile(
                  hoverColor: Colors.black12,
                  dense: false,
                  title: Text(
                    recipes[index].name,
                    style: const TextStyle(
                        fontSize: 32,
                        fontFamily: "Montserrat",
                        color: Colors.black87),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image(
                    image: AssetImage(recipes[index].imageUrl),
                  ),
                  onTap: () => print("${recipes[index].id} on tap"),
                )


Card(
              elevation: 10,
              margin: const EdgeInsets.symmetric(vertical: 7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const SizedBox(width: 10),
                Expanded(child: Image.asset(recipes[index].imageUrl)),
                Expanded(
                  child: Center(
                    child: Text(
                      recipes[index].name,
                      style: const TextStyle(
                          fontSize: 32, fontFamily: "Montserrat"),
                    ),
                  ),
                ),
              ]),
            ),

Image.asset("assets/images/sk.png"),

class VoiceRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("VoiceRecipe"),
          centerTitle: true,
          // backgroundColor: Colors.amberAccent,
        ),
        body: RichText(
            text: const TextSpan(
          style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.normal,
            // fontWeight: FontWeight.bold,
            // letterSpacing: 3.0,
            color: Colors.black87,
            fontFamily: "Montserrat",
            // decoration: TextDecoration.underline
          ),
              children: <TextSpan>[
                TextSpan(text: "Hello "),
                TextSpan(children: <TextSpan>[
                  TextSpan(text: "Brave "),
                  TextSpan(text: "New "),
                  TextSpan(text: "World ")
                ], style: TextStyle(color: Colors.red))
              ]
        )),
        floatingActionButton: const FloatingActionButton(
          onPressed: handle,
          child: Text("add"),
        ),
      ),
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}
 */
// body: const Text(
// "Hello world",
// style: TextStyle(
// fontSize: 32,
// fontStyle: FontStyle.normal,
// // fontWeight: FontWeight.bold,
// // letterSpacing: 3.0,
// color: Colors.black87,
// fontFamily: "Montserrat",
// // decoration: TextDecoration.underline
// ),
// ),
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
