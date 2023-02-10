import 'package:chronochroma/chronochroma.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../chronochroma.dart';
import 'package:flutter/material.dart';

class gameOver extends StatefulWidget {
  static const String ID = "gameOver";
  final Chronochroma gameRef;
  const gameOver({Key? key, required this.gameRef});

  @override
  State<gameOver> createState() => _gameOverState();
}

class _gameOverState extends State<gameOver> {
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
            const Image(
              image: AssetImage('assets/images/gameOver.png'),
              width: 500,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/salon');
                    },
                    child: const Text(
                      "Retour au salon",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/game');
                      },
                      child: const Text(
                        "Rejouer",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
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
