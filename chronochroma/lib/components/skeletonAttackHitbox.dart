import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/unstableFloor.dart';
import 'package:chronochroma/components/worldCollides.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:chronochroma/components/player.dart';

class SkeletonAttackHitbox extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  
  final RectangleHitbox hitbox;

  SkeletonAttackHitbox(size, position) : hitbox = RectangleHitbox(size : size, position : position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox.debugMode = true;
    hitbox.debugColor = Colors.green;
    hitbox.isSolid = true;
    anchor = Anchor.center;
    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if(other is Player){
      gameRef.player.subirDegat(1);
      removeFromParent();
    }
  }
}