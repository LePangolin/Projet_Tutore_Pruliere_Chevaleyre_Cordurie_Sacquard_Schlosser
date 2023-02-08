import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'worldCollides.dart';

class Projectile extends SpriteComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  double x;
  double y;
  late final SpriteAnimation _animation;

  Projectile(this.x, this.y) : super(size: Vector2(50, 24));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('arrow.png')
      ..srcSize = Vector2.all(32);
    position = Vector2(x, y);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) async {
    super.update(dt);
  }
}
