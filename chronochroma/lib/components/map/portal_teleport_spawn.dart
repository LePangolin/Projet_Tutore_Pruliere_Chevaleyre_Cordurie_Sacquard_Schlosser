import 'package:chronochroma/components/map/return_spawn_objects.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class TeleportSpawnPortal extends ReturnSpawnObjects {
  final TiledObject teleportSpawnPortal;
  late SpriteAnimation _animation;

  TeleportSpawnPortal(this.teleportSpawnPortal) : super(teleportSpawnPortal) {
    super.delay = 1000;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations().then((_) => {animation = _animation});
    super.size = Vector2.all(128);
    super.position =
        Vector2(teleportSpawnPortal.x + 64, teleportSpawnPortal.y + 24);
    super.hitbox.position = Vector2(64, 40);
    anchor = Anchor.centerRight;
    // add a color effect to the portal
    add(ColorEffect(
      const Color.fromARGB(255, 11, 23, 130),
      const Offset(0.2, 0.6),
      EffectController(
        duration: 1,
        reverseDuration: 1,
        infinite: true,
      ),
    ));
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('dynamic_elements/redPortal.png'),
      columns: 8,
      rows: 3,
    );

    _animation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 7);
  }
}
