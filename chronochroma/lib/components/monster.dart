import 'dart:developer';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'worldCollides.dart';
import 'package:chronochroma/components/projectile.dart';

class Monster extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  int health = 25;
  bool needUpdate = true;
  final TiledObject monster;

  late final SpriteAnimation _animation;

  Monster(this.monster) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations().then((_) => {animation = _animation});
    position = Vector2(monster.x, monster.y);
    anchor = Anchor.center;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = await SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('character/32x32-bat-sprite.png'),
      columns: 4,
      rows: 4,
    );

    _animation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 1, to: 3);
  }

  @override
  void update(double dt) async {
    super.update(dt);

    if (needUpdate) {
      needUpdate = false;
      gameRef.getCurrentLevel()!.addObject(Projectile(monster.x, monster.y));
      await Future.delayed(Duration(seconds: 3))
          .then((_) => {needUpdate = true});
    }
  }
}
