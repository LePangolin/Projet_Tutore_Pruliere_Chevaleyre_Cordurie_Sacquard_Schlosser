import 'package:chronochroma/chronochroma.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import "./chronochroma.dart";

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
    return Container();
  }
}
