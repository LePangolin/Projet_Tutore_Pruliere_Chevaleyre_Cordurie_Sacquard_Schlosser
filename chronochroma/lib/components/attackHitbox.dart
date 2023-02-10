import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class AttackHitbox extends RectangleHitbox {
  AttackHitbox()
      : super(
          size: Vector2(70, 85),
          position: Vector2(256 / 2 - 12, 35),
          isSolid: true,
        );

  // another constructor
  AttackHitbox.position(Vector2 positionPlayer) {
    size = Vector2(70, 70);
    isSolid = true;
    position = Vector2(positionPlayer.x + 256 / 2 - 12, positionPlayer.y + 35);
    print("x: ${position.x} y: ${position.y}");
  }
}
