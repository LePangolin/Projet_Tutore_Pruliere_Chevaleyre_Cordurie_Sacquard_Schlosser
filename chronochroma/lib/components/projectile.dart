import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/unstableFloor.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'worldCollides.dart';
import 'package:chronochroma/components/player.dart';

class Projectile extends SpriteComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  double x;
  double y;
  late final SpriteAnimation _animation;
  Vector2 velocity = Vector2(2, 0);
  int degat = 50;
  bool isLeft;

  Projectile(this.x, this.y, this.isLeft) : super(size: Vector2(50, 24));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('arrow.png');
    if (!isLeft) {
      flipHorizontallyAroundCenter();
    }
    position = Vector2(x, y);
    anchor = Anchor.center;
    RectangleHitbox hitbox = RectangleHitbox(size: Vector2(50, 24));

    hitbox.debugMode = true;
    add(hitbox);
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (isLeft) {
      position.x -= 1;
    } else {
      position.x += 1;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player || other is WorldCollides || other is UnstableFloor) {
      removeFromParent();
    }
    if (other is Player) {
      gameRef.player.subirDegat(degat);
    }
  }
}
