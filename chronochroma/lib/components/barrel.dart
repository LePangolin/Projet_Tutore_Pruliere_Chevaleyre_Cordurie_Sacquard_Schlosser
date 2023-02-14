import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/attackHitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'player.dart';

class Barrel extends SpriteComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject barrel;
  bool _isPresent = true;

  Barrel(this.barrel);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('barrel.png')
      ..srcSize = Vector2.all(32);
    size = Vector2.all(32);
    position = Vector2(barrel.x, barrel.y);
    RectangleHitbox hitbox = RectangleHitbox(size: Vector2.all(32));
    hitbox.debugMode = true;
    add(hitbox);
    anchor = Anchor.center;
  }

  // Supprime le sol quand il entre en collision avec le joueur
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AttackHitbox && gameRef.player.isAttacking) {
      if (_isPresent) {
        _isPresent = false;

        // wait 1 second before removing the barrel
        Future.delayed(const Duration(milliseconds: 360), () {
          removeFromParent();
          // camera shake
          gameRef.camera.shake(duration: 0.1, intensity: 5);
        });

        Future.delayed(const Duration(seconds: 1), () {
          _isPresent = true;
        });
      }
    }
  }
}
