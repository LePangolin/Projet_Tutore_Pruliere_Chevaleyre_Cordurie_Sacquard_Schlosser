import 'dart:ui';

import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/game.dart';
import 'arena.dart';
import 'player.dart';

class Chronochroma extends FlameGame {
  final Player _player = Player();
  final Arena _arena = Arena();
  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_arena);
    await add(_player);
    _player.position = _arena.size / 1.5;
    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _arena.size.x, _arena.size.y));
  }

  onArrowKeyChanged(Direction direction) {
    _player.direction = direction;
  }
}
