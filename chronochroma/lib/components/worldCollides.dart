import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class WorldCollides extends PositionComponent {
  WorldCollides({required size, required position})
      : super(size: size, position: position);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
