import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Améliorer mon personnage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int lvl = 0;
  int points = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          // add a image on top of joystick which will move according to joystick movement
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Niveau: $lvl",
                style: TextStyle(
                  color: Color.fromARGB(221, 255, 255, 255),
                  fontFamily: 'Calibri',
                  letterSpacing: 0.5,
                  fontSize: 15,
                ),
              ),
              Text(
                "Points: $points",
                style: TextStyle(
                  color: Color.fromARGB(221, 255, 255, 255),
                  fontFamily: 'Cailibri',
                  letterSpacing: 0.5,
                  fontSize: 14,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40, top: 10),
                child: ElevatedButton(
                    onPressed: () {
                      if (points >= 1) {
                        lvl += 1;
                        points -= 1;
                      }
                      setState(() {});
                    },
                    child: const Text("Niveau supérieur")),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Align(
                    alignment: const Alignment(0.0, 0.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/idle.gif'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          )),
    );
  }
}
