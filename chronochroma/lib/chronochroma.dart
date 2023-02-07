
import 'dart:math';

import 'package:chronochroma/components/monster.dart';
import 'package:chronochroma/components/unstableFloor.dart';
import 'package:chronochroma/components/worldCollides.dart';
import 'package:chronochroma/components/level.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/player.dart';


class Chronochroma extends FlameGame with HasCollisionDetection {
  final Player player = Player();
  Level? _currentLevel;
  List<String> levelsNames = ['newMethods.tmx', 'playground.tmx'];
  SpriteComponent? overlayComponent;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Par précaution, on met le jeu en plein écran et en paysage
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    // On charge la map
    loadLevel('newMethods.tmx');

    // fixe une résolution qui s'adapte à l'écran
    camera.viewport = FixedResolutionViewport(Vector2(1600, 900));

    // On fixe le zoom initial
    camera.zoom = 1.75;

    overlayComponent = SpriteComponent(
        sprite: await loadSprite('fadeBackground.jpg'),
        paint: Paint()..color = const Color.fromARGB(0, 0, 0, 0),
        priority: 1000,
        size: Vector2(940, 520),
        position: Vector2(564, 480),
        anchor: Anchor.center);



    add(overlayComponent!);

  }

  // Influence la direction du joueur
  onArrowKeyChanged(Direction direction) {
    player.direction = direction;
  }

  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
    // wait for the level to load
    _currentLevel!.onLoad().then((_) {
      // On ajoute le joueur à la scène
      add(player);
      // On place le joueur au spawn
      player.teleport(_currentLevel!.spawnPoint);
      // On suit le joueur en respectant les limites de la map
      camera.followComponent(player,
          worldBounds: Rect.fromLTRB(
              0, 0, _currentLevel!.level.size.x, _currentLevel!.level.size.y));
      print(_currentLevel!.level.size.x);
      print(_currentLevel!.level.size.y);
    });
  }
}
