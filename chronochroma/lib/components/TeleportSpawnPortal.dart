import 'dart:ui';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class TeleportSpawnPortal extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject teleportSpawnPortal;
  bool _isPresent = true;
  late SpriteAnimation _animation;

  TeleportSpawnPortal(this.teleportSpawnPortal);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations().then((_) => {animation = _animation});
    size = Vector2.all(128);
    position = Vector2(teleportSpawnPortal.x + 64, teleportSpawnPortal.y + 24);
    RectangleHitbox hitbox = RectangleHitbox(
        size: Vector2(teleportSpawnPortal.width, teleportSpawnPortal.height),
        anchor: Anchor.topLeft,
        position: Vector2(64, 40));
    hitbox.debugMode = true;
    hitbox.isSolid = true;
    add(hitbox);
    anchor = Anchor.centerRight;
    // add a color effect to the portal
    add(ColorEffect(
      const Color.fromARGB(255, 11, 23, 130),
      const Offset(0.2, 0.6),
      EffectController(
        duration: 1,
        reverseDuration: 1,
        infinite: true,
      ),
    ));
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('redPortal.png'),
      columns: 8,
      rows: 3,
    );

    _animation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 7);
  }

  // Retour au spawn
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      if (_isPresent) {
        _isPresent = false;
        gameRef.sendPlayerToSpawn();
        Future.delayed(const Duration(seconds: 1), () {
          _isPresent = true;
        });
      }
    }
  }
}
