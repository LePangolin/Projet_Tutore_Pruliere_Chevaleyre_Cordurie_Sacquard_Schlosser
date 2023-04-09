import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class UnstableFloor extends SpriteComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject unstableFloor;
  bool isPresent = true;

  UnstableFloor(this.unstableFloor);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('dynamic_elements/placeholder.png')
      ..srcSize = Vector2.all(32);
    size = Vector2(unstableFloor.width, unstableFloor.height);
    position = Vector2(unstableFloor.x, unstableFloor.y);
    RectangleHitbox hitbox = RectangleHitbox(
      size: Vector2(unstableFloor.width, unstableFloor.height),
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
        int levelIt = gameRef.currentLevelIter;
        Future.delayed(const Duration(seconds: 2), () {
          removeFromParent();
          Future.delayed(const Duration(seconds: 2), () {
            if (levelIt == gameRef.currentLevelIter) {
              gameRef.currentLevel?.add(UnstableFloor(unstableFloor));
              isPresent = true;
            }
          });
        });
      }
    }
  }
}
