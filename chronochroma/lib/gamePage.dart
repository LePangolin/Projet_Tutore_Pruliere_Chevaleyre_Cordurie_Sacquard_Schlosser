import 'package:chronochroma/overlays/controll.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../chronochroma.dart';
import './helpers/controller.dart';
import 'overlays/gameOver.dart';

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
              GameOver.ID: (BuildContext context, Chronochroma game) =>
                  GameOver(gameRef: game),
              Controll.ID: (BuildContext context, Chronochroma game) =>
                  Controll(gameRef: game)
            },
          ),
        ],
      ),
    );
  }
}
