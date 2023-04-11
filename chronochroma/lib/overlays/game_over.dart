import 'package:chronochroma/chronochroma.dart';
import 'package:flutter/material.dart';
import '../components/compte.dart';

class GameOver extends StatefulWidget {
  static const String ID = "gameOver";
  final Chronochroma gameRef;
  const GameOver({Key? key, required this.gameRef});

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    connected();
    print('isConnected: $isConnected');
  }

  void connected() async {
    if (await Compte.getInstance() != null) {
      setState(() {
        isConnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: isConnected ? 20 : 0),
              child: Image(
                image: widget.gameRef.win
                    ? const AssetImage('assets/images/logoMEILLEUREVER.png')
                    : const AssetImage('assets/images/gameOver.png'),
                width: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 2 texts
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Score: ${widget.gameRef.endGameReward()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    'Temps: ${widget.gameRef.chronometerMinutesSecondes()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )),
            if (!isConnected)
              const Text(
                'Créez vous un compte pour sauvegarder vos prochaines parties.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: IconButton(
                      icon: Image.asset('assets/images/button_quitter.png'),
                      iconSize: MediaQuery.of(context).size.width * 0.17,
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/salon');
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      icon: Image.asset('assets/images/button_rejouer.png'),
                      iconSize: MediaQuery.of(context).size.width * 0.17,
                      onPressed: () {
                        if (widget.gameRef.setSeed) {
                          Navigator.popAndPushNamed(context, '/game',
                              arguments: widget.gameRef.seed);
                        } else {
                          Navigator.popAndPushNamed(context, '/game');
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
