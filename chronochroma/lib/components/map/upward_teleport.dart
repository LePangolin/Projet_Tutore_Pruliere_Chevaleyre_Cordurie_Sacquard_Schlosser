import 'dart:ui';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/entities/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class UpwardTeleport extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject upwardteleport;
  late final SpriteAnimation _baseAnimation;
  late double upwardTeleportValue;

  UpwardTeleport(this.upwardteleport);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    upwardTeleportValue =
        upwardteleport.properties.getValue<double>('upLevel') ?? 1;

    await _loadAnimations().then((_) => {animation = _baseAnimation});
    size = Vector2.all(128);
    position = Vector2(upwardteleport.x + 64, upwardteleport.y + 24);
    RectangleHitbox hitbox = RectangleHitbox(
        size: Vector2(upwardteleport.width, upwardteleport.height),
        anchor: Anchor.topLeft,
        position: Vector2(64, 40));
    hitbox.debugMode = false;
    add(hitbox);
    anchor = Anchor.centerRight;
    add(ColorEffect(
      const Color.fromARGB(255, 20, 100, 0),
      const Offset(0.2, 0.6),
      EffectController(
        duration: 1,
        infinite: true,
      ),
    ));
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('dynamic_elements/upPortal.png'),
      columns: 8,
      rows: 3,
    );

    _baseAnimation = spriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 7, loop: true);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      gameRef.player.teleportRelative(Vector2(0, -32 * upwardTeleportValue));
      gameRef.camera.shake(duration: 0.3, intensity: 10);
    }
  }
}
