import 'dart:ui';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';

class NextLevelDoor extends SpriteComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject nextLevelDoor;
  bool isPresent = true;

  NextLevelDoor(this.nextLevelDoor);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('grass/dirt.png')
      ..srcSize = Vector2.all(32);
    size = Vector2(nextLevelDoor.width, nextLevelDoor.height);
    position = Vector2(nextLevelDoor.x, nextLevelDoor.y);
    RectangleHitbox hitbox = RectangleHitbox(
      size: Vector2(nextLevelDoor.width, nextLevelDoor.height),
    );
    hitbox.debugMode = true;
    add(hitbox);
    anchor = Anchor.topLeft;
  }

  // Supprime le sol quand il entre en collision avec le joueur
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      if (isPresent) {
        isPresent = false;
        Future.delayed(const Duration(seconds: 1), () {
          gameRef.overlayComponent?.add(
            ColorEffect(
              const Color.fromARGB(255, 0, 0, 0),
              const Offset(0.0, 1),
              EffectController(duration: 1),
            ),
          );
          gameRef.overlayComponent
              ?.add(OpacityEffect.to(1, EffectController(duration: 1)));
        });
      }
    }
  }
}
