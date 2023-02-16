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
  }

  @override
  Widget build(BuildContext context) {
    // récuperer les arguments de la route
    final args =
        ModalRoute.of(context)!.settings.arguments;
    // si on a une seed custom

    if (args != null) {
      args as int;
      game = Chronochroma(seed: args);
    } else {
      game = Chronochroma();
    }
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
