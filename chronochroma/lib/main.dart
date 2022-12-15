import 'package:chronochroma/chronochroma.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:chronochroma/helpers/navigation_keys.dart';

void main() {
  final game = Chronochroma();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: NavigationKeys(
                onDirectionChanged: game.onArrowKeyChanged,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
