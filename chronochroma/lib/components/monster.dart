import 'dart:developer';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/attackHitbox.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'worldCollides.dart';
import 'package:chronochroma/components/projectile.dart';
import 'package:chronochroma/components/player.dart';

class Monster extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  int health = 25;
  bool needUpdate = true;
  final TiledObject monster;
  int degat = 3;

  late final SpriteAnimation _animationLeft;
  late final SpriteAnimation _animationRight;
  late bool isLeft;

  Monster(this.monster) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations().then((_) => {
          if (gameRef.player.x > monster.x)
            {
              animation = _animationRight,
              isLeft = false,
            }
          else
            {
              animation = _animationLeft,
              isLeft = true,
            }
        });
    position = Vector2(monster.x, monster.y);
    anchor = Anchor.center;
    RectangleHitbox hitbox = RectangleHitbox(size: Vector2(32, 32));

    hitbox.debugMode = true;
    add(hitbox);
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = await SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('character/32x32-bat-sprite.png'),
      columns: 4,
      rows: 4,
    );

    _animationRight =
        spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 1, to: 3);

    _animationLeft =
        spriteSheet.createAnimation(row: 3, stepTime: 0.1, from: 1, to: 3);
  }

  @override
  void update(double dt) async {
    super.update(dt);

    if (gameRef.player.x > monster.x) {
      animation = _animationRight;
      isLeft = false;
    } else {
      animation = _animationLeft;
      isLeft = true;
    }

    if (needUpdate) {
      needUpdate = false;
      gameRef.getCurrentLevel()!.addObject(Projectile(monster.x, monster.y, isLeft));
      await Future.delayed(Duration(seconds: 3))
          .then((_) => {needUpdate = true});
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      gameRef.player.subirDegat(degat);
    } else if (other is AttackHitbox) {
      health -= 25;
      if (health <= 0) {
        removeFromParent();
      }
    }
  }
}
