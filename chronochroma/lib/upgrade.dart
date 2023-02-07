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
  int sante = 10;
  int vitesse = 10;
  int force = 10;
  int vision = 10;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 25,
                    ),
                    label: Text("Retour")),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: const Alignment(0.0, 0.0),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/idle.gif'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Santé : $sante",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Force : $force",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Vitesse : $vitesse",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Vision : $vision",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ])),
                  Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "Santé +",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "Force +",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "Vitesse +",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "Vision +",
                              style: TextStyle(
                                color: Color.fromARGB(221, 255, 255, 255),
                                fontFamily: 'Calibri',
                                letterSpacing: 0.5,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ],
          )),
    );
  }
}
