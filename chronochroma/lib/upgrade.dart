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
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          padding: const EdgeInsets.only(top:30, bottom: 30, left: 20, right: 20),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/upgrades/background.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Santé : $sante",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 32, 140, 15),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Force : $force",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 42, 42),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Vision : $vision",
                                style: TextStyle(
                                  color: Color.fromARGB(253, 129, 3, 255),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Vitesse : $vitesse",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 10, 104, 255),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                              ),
                          )],
                          ),
                        )
                      ])),
                  Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Image.asset('assets/images/upgrades/health.png'),
                            iconSize: 50,
                            onPressed: () => {}
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/upgrades/atk.png'),
                            iconSize: 50,
                            onPressed: () => {}
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/upgrades/vision.png'),
                            iconSize: 50,
                            onPressed: () => {}
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/upgrades/speed.png'),
                            iconSize: 50,
                            onPressed: () => {}
                          ),
                        ],
                      ))
                ],
              ),
            ],
          )),
    );
  }
}
