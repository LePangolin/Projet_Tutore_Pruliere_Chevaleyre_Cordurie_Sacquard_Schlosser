import 'dart:async';

import 'package:chronochroma/overlays/controll.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:themed/themed.dart';

import '../chronochroma.dart';
import '../overlays/game_over.dart';
import 'package:audioplayers/audioplayers.dart';

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
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      try {
        setState(() {
          saturation = game.player.saturation;
        });
      } catch (e) {}
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      game = Chronochroma(seed: int.parse(args.toString()));
    } else {
      game = Chronochroma();
    }
  }

  @override
  Widget build(BuildContext context) {
    // récuperer les arguments de la route

    // si on a une seed custom
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
