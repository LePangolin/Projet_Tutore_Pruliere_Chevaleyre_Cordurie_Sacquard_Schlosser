import 'dart:ui';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class Coin extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject coin;
  bool _isPresent = true;
  late SpriteAnimation _animation;

  Coin(this.coin);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations().then((_) => {animation = _animation});
    size = Vector2.all(24);
    position = Vector2(coin.x, coin.y);
    RectangleHitbox hitbox = RectangleHitbox(
        size: Vector2.all(32),
        anchor: Anchor.topLeft,
        position: Vector2(-4, -4));
    hitbox.debugMode = true;
    add(hitbox);
    anchor = Anchor.center;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('dynamic_elements/spinningCoin.png'),
      columns: 6,
      rows: 1,
    );

    _animation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.12, from: 0, to: 5);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      if (_isPresent) {
        removeFromParent();
        _isPresent = false;
        gameRef.addCoin(1);
      }
    }
  }
}
