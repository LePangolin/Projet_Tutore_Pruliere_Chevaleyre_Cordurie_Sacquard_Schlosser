import 'package:chronochroma/chronochroma.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class AttackHitbox extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  
  final RectangleHitbox hitbox;
  AttackHitbox(size, position) : hitbox = RectangleHitbox(size : size, position : position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox.debugMode = true;
    hitbox.debugColor = Colors.green;
    hitbox.isSolid = true;
    anchor = Anchor.center;
    add(hitbox);
  }
}

