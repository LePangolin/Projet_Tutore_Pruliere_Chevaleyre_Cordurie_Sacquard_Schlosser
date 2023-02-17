import 'dart:ui';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class FireTrap extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject fireTrap;
  bool _isPresent = true;
  late SpriteAnimation _animation;
  late RectangleHitbox hitbox;
  late int atkDelay;
  final List<int> atkDelayLevels = [3000, 3500, 4000, 5000, 6000];
  late double speed;
  final List<double> speedLevels = [0.15, 0.13, 0.12, 0.11, 0.10];

  FireTrap(this.fireTrap);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    atkDelay = atkDelayLevels[gameRef.compte?.persoVueMax ?? 0];
    speed = speedLevels[gameRef.compte?.persoVueMax ?? 0];
    await _loadAnimations().then((_) => {animation = _animation});
    size = Vector2(64, 128);
    position = Vector2(fireTrap.x, fireTrap.y);
    hitbox = RectangleHitbox(
        size: Vector2(32, 64),
        anchor: Anchor.topLeft,
        position: Vector2(16, 64),
        isSolid: true);
    hitbox.debugMode = true;
    hitbox.isSolid = true;
    anchor = Anchor.bottomCenter;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('FireTrap.png'),
      columns: 9,
      rows: 1,
    );

    _animation = spriteSheet.createAnimation(
        row: 0, stepTime: speed, from: 0, to: 9, loop: false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isPresent) {
      _isPresent = false;
      _animation.reset();
      _animation.onFrame = (frame) {
        if (frame == 5) {
          add(hitbox);
        }
      };
      _animation.onComplete = () async {
        hitbox.removeFromParent();
        await Future.delayed(Duration(milliseconds: atkDelay)).then((_) {
          _isPresent = true;
        });
      };
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      gameRef.player.subirDegat(100);
    }
  }
}
