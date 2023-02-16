import 'dart:async';

import 'package:chronochroma/overlays/controll.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:themed/themed.dart';

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
  double? saturation = 0;

  @override
  void initState() {
    super.initState();
    game = Chronochroma();
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      try {
        setState(() {
          saturation = game.player.saturation;
        });
      } catch (e) {}
    });
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
          // ChangeColors must follow the changes of saturation values
          ChangeColors(
            hue: 0,
            brightness: 0,
            saturation: saturation!,
            child: (GameWidget(
              game: game,
              overlayBuilderMap: {
                GameOver.ID: (BuildContext context, Chronochroma game) =>
                    GameOver(gameRef: game),
                Controll.ID: (BuildContext context, Chronochroma game) =>
                    Controll(gameRef: game)
              },
            )),
          ),
        ],
      ),
    );
  }
}
