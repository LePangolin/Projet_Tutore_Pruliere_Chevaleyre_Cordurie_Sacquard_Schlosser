import 'package:flutter/material.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key, required this.title});

  final String title;

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  int coins = 2000;
  int sante = 1;
  int vitesse = 1;
  int force = 1;
  int vision = 1;

  List<String> santeMaxCost = ["50", "125", "200", "300", "MAX"];
  List<String> vitesseMaxCost = ["70", "100", "200", "300", "MAX"];
  List<String> forceMaxCost = ["50", "75", "100", "150", "MAX"];
  List<String> visionMaxCost = ["30", "60", "90", "130", "MAX"];

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
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
                    Row(
                      children: [
                        Image.asset("assets/images/coin.png", height: 15),
                        const SizedBox(width: 1),
                        Text(
                          "$coins",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 196, 0),
                            fontFamily: 'Calibri',
                            letterSpacing: 0.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 30)
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
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
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          padding: const EdgeInsets.only(
                              top: 30, bottom: 30, left: 20, right: 20),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/upgrades/background.png'),
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
                                  color: Color.fromARGB(255, 177, 14, 14),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
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
                                  color: Color.fromARGB(255, 56, 102, 175),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      ])),
                  Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                      'assets/images/upgrades/health.png'),
                                  iconSize: 50,
                                  onPressed: () {
                                    if (sante < 5) {
                                      if (coins >= int.parse(santeMaxCost[sante - 1])) {
                                        setState(() {
                                          coins -=
                                              int.parse(santeMaxCost[sante - 1]);
                                          sante++;
                                        });
                                      }
                                    }
                                  }),
                              Row(
                                children: [
                                  Text(
                                    "${santeMaxCost[sante - 1]}",
                                    style: TextStyle(
                                      color: (sante <5) ? Color.fromARGB(255, 255, 196, 0) : Color.fromARGB(255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (sante < 5)
                                    Image.asset("assets/images/coin.png",height: 10)
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                      'assets/images/upgrades/atk.png'),
                                  iconSize: 50,
                                  onPressed: () => {
                                    if (force < 5) {
                                      if (coins >= int.parse(forceMaxCost[force - 1])) {
                                        setState(() {
                                          coins -=
                                              int.parse(forceMaxCost[
                                                  force - 1]);
                                          force++;
                                        })
                                      }
                                    }
                                  }),
                              Row(
                                children: [
                                  Text(
                                    "${forceMaxCost[force - 1]}",
                                    style: TextStyle(
                                      color: (force <5) ? Color.fromARGB(255, 255, 196, 0) : Color.fromARGB(255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (force < 5)
                                    Image.asset("assets/images/coin.png",height: 10)
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                      'assets/images/upgrades/vision.png'),
                                  iconSize: 50,
                                  onPressed: () => {
                                    if (vision < 5) {
                                      if (coins >= int.parse(visionMaxCost[vision - 1])) {
                                        setState(() {
                                          coins -=
                                              int.parse(visionMaxCost[
                                                  vision - 1]);
                                          vision++;
                                        })
                                      }
                                    }
                                  }),
                              Row(
                                children: [
                                  Text(
                                    "${visionMaxCost[vision - 1]}",
                                    style: TextStyle(
                                      color: (vision <5) ? Color.fromARGB(255, 255, 196, 0) : Color.fromARGB(255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (vision < 5)
                                    Image.asset("assets/images/coin.png",height: 10)
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                      'assets/images/upgrades/speed.png'),
                                  iconSize: 50,
                                  onPressed: () => {
                                    if (vitesse < 5) {
                                      if (coins >= int.parse(vitesseMaxCost[vitesse - 1])) {
                                        setState(() {
                                          coins -=
                                              int.parse(vitesseMaxCost[
                                                  vitesse - 1]);
                                          vitesse++;
                                        })
                                      }
                                    }
                                  }),
                              Row(
                                children: [
                                  Text(
                                    "${vitesseMaxCost[vitesse - 1]}",
                                    style: TextStyle(
                                      color: (vitesse <5) ? Color.fromARGB(255, 255, 196, 0) : Color.fromARGB(255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    
                                  ),
                                  if (vitesse < 5)
                                    Image.asset("assets/images/coin.png",height: 10)
                                ],
                              )
                            ],
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
