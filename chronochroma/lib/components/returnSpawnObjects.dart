import 'dart:ui';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

abstract class ReturnSpawnObjects extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject returnSpawnObjects;
  bool _isPresent = true;
  int delay = 100;
  late RectangleHitbox hitbox;

  ReturnSpawnObjects(this.returnSpawnObjects);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    hitbox = RectangleHitbox(
        size: Vector2(returnSpawnObjects.width, returnSpawnObjects.height),
        anchor: Anchor.topLeft,
        position: Vector2(returnSpawnObjects.x, returnSpawnObjects.y));
    hitbox.debugMode = false;
    hitbox.isSolid = true;
    add(hitbox);
    anchor = Anchor.topLeft;
  }

  // Retour au spawn
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      if (_isPresent) {
        _isPresent = false;
        gameRef.sendPlayerToSpawn();
        gameRef.camera.shake(duration: 0.3, intensity: 10);
        Future.delayed(Duration(milliseconds: delay), () {
          _isPresent = true;
        });
      }
    }
  }
}
