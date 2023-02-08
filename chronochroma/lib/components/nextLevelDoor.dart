import 'dart:ui';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';

class NextLevelDoor extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject nextLevelDoor;
  bool _isPresent = true;
  late final SpriteAnimation _baseAnimation;
  late final SpriteAnimation _fadeAnimation;
  late SpriteAnimation _animation = _baseAnimation;

  NextLevelDoor(this.nextLevelDoor);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations().then((_) => {animation = _animation});
    size = Vector2.all(128);
    position = Vector2(nextLevelDoor.x + 64, nextLevelDoor.y + 24);
    RectangleHitbox hitbox = RectangleHitbox(
        size: Vector2(nextLevelDoor.width, nextLevelDoor.height),
        anchor: Anchor.topLeft,
        position: Vector2(64, 40));
    hitbox.debugMode = true;
    add(hitbox);
    anchor = Anchor.centerRight;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('redPortal.png'),
      columns: 8,
      rows: 3,
    );

    _baseAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 7);

    // fade animation that don't loop
    _fadeAnimation = spriteSheet.createAnimation(
        row: 2, stepTime: 0.2, from: 0, to: 7, loop: false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isPresent) {
      animation = _baseAnimation;
    } else {
      animation = _fadeAnimation;
    }
  }

  // Transition vers le niveau suivant
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      if (_isPresent) {
        _isPresent = false;
        // Attend quelques instants
        Future.delayed(const Duration(milliseconds: 500), () async {
          // Fait zoomer la caméra progressivement
          while (gameRef.camera.zoom < 2.5) {
            gameRef.camera.zoom += 0.05;
            await Future.delayed(const Duration(milliseconds: 25));
          }

          gameRef.overlayComponent?.position = gameRef.camera.position;
          gameRef.overlayComponent?.size = gameRef.camera.gameSize;

          // Lance l'effet de transition
          gameRef.overlayComponent?.add(
            ColorEffect(
              const Color.fromARGB(255, 0, 0, 0),
              const Offset(0.0, 1),
              EffectController(duration: 0.5),
            ),
          );
          gameRef.overlayComponent
              ?.add(OpacityEffect.to(1, EffectController(duration: 0.5)));

          // Attend encore quelques instants
          Future.delayed(const Duration(seconds: 1), () {
            // Charge le niveau suivant
            gameRef.loadLevel();
          });
        });
      }
    }
  }
}
