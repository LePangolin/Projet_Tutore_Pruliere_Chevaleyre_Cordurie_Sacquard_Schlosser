import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../chronochroma.dart';
import './helpers/controller.dart';
import './gameOver.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Chronochroma game;
  late Widget gameWidget;

  @override
  void initState() {
    super.initState();
    game = Chronochroma();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              gameOver.ID: (BuildContext context, Chronochroma game) =>
                  gameOver(gameRef: game)
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Controller(
              onDirectionChanged: game.onArrowKeyChanged,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Image.asset('assets/images/icon/swordIcon.png'),
                iconSize: 128,
                onPressed: () => {
                      if (game.player.canAttack)
                        {game.player.isAttacking = true, print('attaque')}
                      else
                        {print('attaque impossible')}
                    }),
          ),
        ],
      ),
    );
  }
}
