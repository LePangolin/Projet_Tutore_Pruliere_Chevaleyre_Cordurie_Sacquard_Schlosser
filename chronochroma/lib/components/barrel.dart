import 'package:chronochroma/chronochroma.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Barrel extends SpriteComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  final TiledObject barrel;
  bool isPresent = true;

  Barrel(this.barrel);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('barrel.png')
      ..srcSize = Vector2.all(32);
    size = Vector2.all(32);
    position = Vector2(barrel.x, barrel.y);
    RectangleHitbox hitbox = RectangleHitbox(
      size: Vector2.all(32),
    );
    hitbox.debugMode = true;
    add(hitbox);
    anchor = Anchor.center;
  }
}
