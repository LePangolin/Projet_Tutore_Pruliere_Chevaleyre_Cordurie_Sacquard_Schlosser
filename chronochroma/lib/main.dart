import 'package:chronochroma/helpers/directions.dart';
import 'package:chronochroma/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'helpers/navigation_keys.dart';

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

class Chronochroma extends FlameGame {
  final Player player = Player();
  double gravity = 1.5;
  Vector2 velocity = Vector2(0, 0);
  late TiledComponent homeMap;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    homeMap = await TiledComponent.load('map.tmx', Vector2.all(32));
    add(homeMap);
    add(player);
  }

  onArrowKeyChanged(Direction direction) {
    player.direction = direction;
  }
}
