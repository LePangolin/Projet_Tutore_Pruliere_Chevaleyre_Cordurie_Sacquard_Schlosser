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
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Image(
                image: const AssetImage('assets/images/gameOver.png'),
                width: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 IconButton(
                    icon: Image.asset('assets/images/button_quitter.png'),
                    iconSize: MediaQuery.of(context).size.width * 0.17,
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/salon');
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      icon: Image.asset('assets/images/button_rejouer.png'),
                      iconSize: MediaQuery.of(context).size.width * 0.17,
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/game');
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
