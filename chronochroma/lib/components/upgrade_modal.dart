import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class UpgradeModal extends StatefulWidget {
  UpgradeModal({Key? key}) : super(key: key);

  @override
  _UpgradeModalState createState() => _UpgradeModalState();
}

/// Classe d'état du widget Modale
class _UpgradeModalState extends State<UpgradeModal> {
  bool _modalOpen = true;
  late bool _dontShowAgain = false;
  int index = 1;
  int numberOfPages = 3;

  @override
  void initState() {
    super.initState();
    getChecked();
  }

  void getChecked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dontShowAgain = prefs.getBool('dontShowAgainUpgrades') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * 0.8;
    final double screenWidth = MediaQuery.of(context).size.width * 0.8;
    final player = AudioPlayer();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: screenHeight,
        width: screenWidth,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Montée en puissance',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: screenWidth * 0.60,
                  height: screenHeight * 0.70,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: getContent(index),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  height: screenHeight * 0.60,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          IconButton(
                            onPressed: () {
                              if (index > 1) {
                                player.play(
                                    AssetSource('audio/interface_click.wav'));
                              }
                              setState(() {
                                index = index <= 1 ? 1 : index - 1;
                              });
                            },
                            icon: Icon(Icons.arrow_back_ios,
                                color: index == 1 ? Colors.grey : Colors.blue),
                          ),
                          Text(
                            '$index/$numberOfPages',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (index < numberOfPages) {
                                player.play(
                                    AssetSource('audio/interface_click.wav'));
                              }
                              setState(() {
                                index = index >= numberOfPages
                                    ? numberOfPages
                                    : index + 1;
                              });
                            },
                            icon: Icon(Icons.arrow_forward_ios,
                                color: index == numberOfPages
                                    ? Colors.grey
                                    : Colors.blue),
                          ),
                        ]),
                        index == numberOfPages
                            ? Column(children: [
                                Row(
                                  children: [
                                    const Text('Ne plus afficher'),
                                    Checkbox(
                                      key: UniqueKey(),
                                      value: _dontShowAgain,
                                      onChanged: (value) {
                                        setState(() {
                                          _dontShowAgain = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    player.play(AssetSource(
                                        'audio/interface_click.wav'));
                                    close();
                                  },
                                  child: const Text('Fermer'),
                                ),
                              ])
                            : Container(),
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getContent(int index) {
    switch (index) {
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Flexible(
              child: SizedBox(
                width: 280,
                child: Text(
                  'Dans Chrono Chroma, votre personnage est trop faible au départ pour espérer atteindre la victoire. Pour y remédier, il faut gagner en puissance via les améliorations disponibles.\n\nLa monnaie de jeu que vous récupérez en tuant des ennemis ou en avançant dans les niveaux est dépensable ici même.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Column(
              children: const [
                Image(
                    image: AssetImage('assets/images/coinGif.gif'),
                    fit: BoxFit.fill,
                    height: 50),
              ],
            )
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Flexible(
              child: SizedBox(
                width: 280,
                child: Text(
                  'L\'augmentation de votre santé maximale allongera votre survie et vous permettra d\'atteindre des niveaux plus éloignés.\n\nLes ennemis sont sources de ralentissement, de dégâts, mais aussi de monnaie. Détruisez les plus rapidement de quelques coups de lame en rendant votre arme plus mortelle.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Column(
              children: const [
                Image(
                    image: AssetImage('assets/images/upgrades/health.png'),
                    fit: BoxFit.fill,
                    height: 50),
                SizedBox(height: 40),
                Image(
                    image: AssetImage('assets/images/upgrades/atk.png'),
                    fit: BoxFit.fill,
                    height: 50),
              ],
            )
          ],
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Flexible(
              child: SizedBox(
                width: 280,
                child: Text(
                  'Une meilleure acuité visuelle boostera les réflexes de votre personnage, les projectiles et pièges seront plus faciles à éviter.\n\nDans une course contre la montre, courir plus vite n\'est pas du luxe. Augmentez votre vitesse de déplacement ainsi que votre vitesse d\'attaque.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Column(
              children: const [
                Image(
                    image: AssetImage('assets/images/upgrades/vision.png'),
                    fit: BoxFit.fill,
                    height: 50),
                SizedBox(height: 40),
                Image(
                    image: AssetImage('assets/images/upgrades/speed.png'),
                    fit: BoxFit.fill,
                    height: 50),
              ],
            )
          ],
        );
      default:
        return const Text(
          'Bon jeu !',
          style: TextStyle(
            fontSize: 16,
          ),
        );
    }
  }

  void close() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dontShowAgainUpgrades', _dontShowAgain);
    setState(() {
      _modalOpen = false;
    });
    Navigator.of(context).pop();
  }

  void open() async {
    setState(() {
      _modalOpen = true;
    });
  }
}
