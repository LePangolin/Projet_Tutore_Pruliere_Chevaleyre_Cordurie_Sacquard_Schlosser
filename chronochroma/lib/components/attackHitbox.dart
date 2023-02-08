import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class AttackHitbox extends RectangleHitbox  
{
  AttackHitbox() : super(
          size: Vector2(70,85),
          position: Vector2(256 / 2 - 12, 35),
          isSolid: true,
        );
}