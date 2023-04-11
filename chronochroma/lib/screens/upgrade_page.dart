import 'package:chronochroma/helpers/character_upgrades.dart';
import 'package:chronochroma/components/compte.dart';
import 'package:flutter/material.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key, required this.title});

  final String title;

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  late Compte? compte;
  int score = 0;
  int sante = 1;
  int vitesse = 1;
  int force = 1;
  int vision = 1;
  final List<String> santeMaxCost = ["50", "125", "200", "300", "MAX"];
  final List<String> vitesseMaxCost = ["70", "100", "200", "300", "MAX"];
  final List<String> forceMaxCost = ["50", "75", "100", "150", "MAX"];
  final List<String> visionMaxCost = ["30", "60", "90", "130", "MAX"];
  bool pendingRequest = false;

  @override
  void initState() {
    super.initState();
    _loadCompte();
  }

  Future<void> _loadCompte() async {
    compte = await Compte.getInstance();
    if (compte == null) {
      setState(() {
        sante = 1;
        vitesse = 1;
        force = 1;
        vision = 1;
        score = 0;
      });
    } else {
      setState(() {
        sante = compte?.persoVieMax ?? 1;
        vitesse = compte?.persoVitesseMax ?? 1;
        force = compte?.persoForceMax ?? 1;
        vision = compte?.persoVueMax ?? 1;
        score = compte?.score ?? 0;
      });
    }
  }

  void _upgrade(int statLevel, CharacterUpgrades skillToUpgrade,
      List<String> statCostArray) {
    // S'il n'y a pas de requête en cours ET que le niveau de la statistique est inférieur au nombre de niveaux possibles ET que le joueur a assez de pièces
    if (!pendingRequest &&
        statLevel < statCostArray.length &&
        score >= int.parse(statCostArray[statLevel - 1])) {
      // Alors une requête est lancée
      pendingRequest = true;
      Compte.upgradeCharacter(skillToUpgrade).then((applied) async {
        // Si la requête a abouti
        if (applied) {
          // Alors on met à jour les données du joueur
          bool updated = await Compte.updateScore(-(int.parse(statCostArray[statLevel - 1])));
          setState(() {
            if (updated) {
              switch (skillToUpgrade) {
                case CharacterUpgrades.vie:
                  sante++;
                  break;
                case CharacterUpgrades.vitesse:
                  vitesse++;
                  break;
                case CharacterUpgrades.force:
                  force++;
                  break;
                case CharacterUpgrades.vue:
                  vision++;
                  break;
              }
              score = compte?.score ?? 0;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Amélioration effectuée'),
            )
          );
        } else {
          // Sinon on affiche un message d'erreur
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('L\'amélioration n\'a pas pu être enrégistrée'),
          ));
        }
        // On indique que la requête est terminée
        pendingRequest = false;
      });
    } else {
      // Sinon on affiche un message d'erreur si aucun ScaffoldMessenger n'est présent
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (pendingRequest) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Une amélioration est déjà en cours'),
        ));
      } else if (statLevel >= statCostArray.length) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Vous avez atteint le niveau maximum dans cette compétence'),
        ));
      } else if (score < int.parse(statCostArray[statLevel - 1])) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vous n\'avez pas assez de pièces'),
        ));
      }
    }
  }

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
                        label: const Text("Retour")),
                    Row(
                      children: [
                        Image.asset("assets/images/coin.png", height: 15),
                        const SizedBox(width: 1),
                        Text(
                          "$score",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 196, 0),
                            fontFamily: 'Calibri',
                            letterSpacing: 0.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 30)
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
                              height: 155,
                              width: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/gifU.gif'),
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
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 32, 140, 15),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Force : $force",
                                style: const TextStyle(
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
                                style: const TextStyle(
                                  color: Color.fromARGB(253, 129, 3, 255),
                                  fontFamily: 'Calibri',
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Vitesse : $vitesse",
                                style: const TextStyle(
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
                                  onPressed: () => {
                                        _upgrade(sante, CharacterUpgrades.vie,
                                            santeMaxCost)
                                      }),
                              Row(
                                children: [
                                  Text(
                                    santeMaxCost[sante - 1],
                                    style: TextStyle(
                                      color: (sante < santeMaxCost.length)
                                          ? const Color.fromARGB(
                                              255, 255, 196, 0)
                                          : const Color.fromARGB(
                                              255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (sante < santeMaxCost.length)
                                    Image.asset("assets/images/coin.png",
                                        height: 10)
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                      'assets/images/upgrades/atk.png'),
                                  iconSize: 50,
                                  onPressed: () => {
                                        _upgrade(force, CharacterUpgrades.force,
                                            forceMaxCost)
                                      }),
                              Row(
                                children: [
                                  Text(
                                    forceMaxCost[force - 1],
                                    style: TextStyle(
                                      color: (force < forceMaxCost.length)
                                          ? const Color.fromARGB(
                                              255, 255, 196, 0)
                                          : const Color.fromARGB(
                                              255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (force < forceMaxCost.length)
                                    Image.asset("assets/images/coin.png",
                                        height: 10)
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                      'assets/images/upgrades/vision.png'),
                                  iconSize: 50,
                                  onPressed: () => {
                                        _upgrade(vision, CharacterUpgrades.vue,
                                            visionMaxCost)
                                      }),
                              Row(
                                children: [
                                  Text(
                                    visionMaxCost[vision - 1],
                                    style: TextStyle(
                                      color: (vision < visionMaxCost.length)
                                          ? const Color.fromARGB(
                                              255, 255, 196, 0)
                                          : const Color.fromARGB(
                                              255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (vision < visionMaxCost.length)
                                    Image.asset("assets/images/coin.png",
                                        height: 10)
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                      'assets/images/upgrades/speed.png'),
                                  iconSize: 50,
                                  onPressed: () => {
                                        _upgrade(
                                            vitesse,
                                            CharacterUpgrades.vitesse,
                                            vitesseMaxCost)
                                      }),
                              Row(
                                children: [
                                  Text(
                                    vitesseMaxCost[vitesse - 1],
                                    style: TextStyle(
                                      color: (vitesse < vitesseMaxCost.length)
                                          ? const Color.fromARGB(
                                              255, 255, 196, 0)
                                          : const Color.fromARGB(
                                              255, 255, 136, 0),
                                      fontFamily: 'Calibri',
                                      letterSpacing: 0.5,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (vitesse < vitesseMaxCost.length)
                                    Image.asset("assets/images/coin.png",
                                        height: 10)
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
