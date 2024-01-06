import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int counter = 0;

  void onClicked() {
    setState(() {
      counter = counter + 1;
    });
  }

  void onMinus() {
    setState(() {
      counter = counter - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFF4EDDB),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Click Count',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '$counter',
                  style: const TextStyle(fontSize: 30),
                ),
                Row(
                  children: [
                    IconButton(
                        iconSize: 40,
                        onPressed: onClicked,
                        icon: const Icon(Icons.add_box_rounded)),
                    IconButton(
                        iconSize: 40,
                        onPressed: onMinus,
                        icon: const Icon(Icons.remove_circle_rounded)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
