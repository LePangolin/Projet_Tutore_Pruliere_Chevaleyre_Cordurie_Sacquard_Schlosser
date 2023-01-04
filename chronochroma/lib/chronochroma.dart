import 'package:flame_tiled/flame_tiled.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:chronochroma/player.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Chronochroma extends FlameGame {
  final Player player = Player();
  late TiledComponent homeMap;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    homeMap = await TiledComponent.load('map.tmx', Vector2.all(32));
    add(homeMap);
    add(player);
    camera.followComponent(player);
  }

  // Influence la direction du joueur
  onArrowKeyChanged(Direction direction) {
    player.direction = direction;
  }
}
