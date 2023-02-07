import 'package:flutter/material.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key, required this.title});

  final String title;

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
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
              image: AssetImage('assets/images/bg_1.png'),
              fit: BoxFit.cover,
              scale: 2.0,
            ),
          ),
          // add a image on top of joystick which will move according to joystick movement
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/salon');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 25,
                    ),
                    label: Text("Retour")),
              ),
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
