import 'package:flame/components.dart';

class Arena extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('arena.png');
    size = sprite!.originalSize;
  }
}
