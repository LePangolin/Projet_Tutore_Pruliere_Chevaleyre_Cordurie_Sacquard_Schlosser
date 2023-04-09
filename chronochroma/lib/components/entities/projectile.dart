import 'package:chronochroma/screens/chronochroma.dart';
import 'package:chronochroma/components/map/unstable_floor.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../map/world_collides.dart';
import 'package:chronochroma/components/entities/player.dart';

class Projectile extends SpriteComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  double x;
  double y;
  Vector2 velocity = Vector2(2, 0);
  bool isLeft;
  late int degat;
  late int speed;
  final List speedLevels = [3, 3, 2, 2, 1];

  Projectile(this.x, this.y, this.isLeft) : super(size: Vector2(50, 24));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    degat = 50 + gameRef.currentLevelIter * 20;
    speed = speedLevels[gameRef.compte?.persoVueMax ?? 0];

    sprite = await gameRef.loadSprite('monsters/bat/arrow.png');
    if (!isLeft) {
      flipHorizontallyAroundCenter();
    }
    position = Vector2(x, y);
    anchor = Anchor.center;
    RectangleHitbox hitbox = RectangleHitbox(size: Vector2(50, 24));

    hitbox.debugMode = false;
    add(hitbox);
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (isLeft) {
      position.x -= speed;
    } else {
      position.x += speed;
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
