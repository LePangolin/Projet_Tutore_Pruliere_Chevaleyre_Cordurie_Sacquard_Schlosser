import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/monster.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'skeleton.dart';

class AttackHitbox extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final RectangleHitbox hitbox;
  AttackHitbox(size, position)
      : hitbox = RectangleHitbox(size: size, position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox.debugMode = false;
    hitbox.debugColor = Colors.green;
    hitbox.isSolid = true;
    anchor = Anchor.center;
    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Skeleton || other is Monster) {
      // if has parent
      if (parent != null) {
        removeFromParent();
      }
    }
  }
}
