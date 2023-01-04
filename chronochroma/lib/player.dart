import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  // Attributs de direction et d'animation
  double gravity = 1.2;
  Vector2 velocity = Vector2(0, 0);
  Direction direction = Direction.none;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkLeftAnimation;
  late final SpriteAnimation _walkRightAnimation;

  // Vitesse d'animation : plus c'est haut, plus c'est lent
  final double _idleAnimationSpeed = 0.25;
  final double _walkAnimationSpeed = 0.1;

  Player() : super(size: Vector2.all(100)) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _idleAnimation});
    size = Vector2.all(100);
    position = Vector2(100, 100);
  }

// Animations correspondantes à des états pour le personnage
  Future<void> _loadAnimations() async {
    final idleSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('knight_idle_spritesheet.png'),
      columns: 6,
      rows: 1,
    );
    final walkLeftSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('knight_walk_left_spritesheet.png'),
        columns: 6,
        rows: 1);
    final walkRightSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('knight_walk_right_spritesheet.png'),
        columns: 6,
        rows: 1);

    _idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: _idleAnimationSpeed, from: 0, to: 5);

    _walkLeftAnimation = walkLeftSpriteSheet.createAnimation(
        row: 0, stepTime: _walkAnimationSpeed, from: 0, to: 5);

    _walkRightAnimation = walkRightSpriteSheet.createAnimation(
        row: 0, stepTime: _walkAnimationSpeed, from: 0, to: 5);
  }

// dt pour delta time, c'est le temps de raffraichissement
  @override
  void update(double dt) {
    super.update(dt);
    if (position.y < 32 * 23 - height) {
      if (velocity.y < 20) {
        velocity.y += gravity / 5;
      }
      position += velocity;
    } else {
      velocity.y = 0;
    }
    updatePosition(dt);
  }

// Déplacement du personnage et animation correspondante
  updatePosition(double dt) {
    switch (direction) {
      case Direction.up:
        animation = _walkRightAnimation;
        position.y -= 15;
        break;
      case Direction.down:
        animation = _walkLeftAnimation;
        if (position.y < 32 * 23 - height) {
          position.y += 25;
        }
        break;
      case Direction.left:
        animation = _walkLeftAnimation;
        position.x -= 5;
        break;
      case Direction.right:
        animation = _walkRightAnimation;
        position.x += 5;
        break;
      case Direction.none:
        animation = _idleAnimation;
        break;
      case Direction.upLeft:
        animation = _walkLeftAnimation;
        position.y -= 15;
        position.x -= 5;
        break;
      case Direction.upRight:
        animation = _walkRightAnimation;
        position.y -= 15;
        position.x += 5;
        break;
      case Direction.downLeft:
        animation = _walkLeftAnimation;
        if (position.y < 32 * 23 - height) {
          position.y += 25;
        }
        position.x -= 5;
        break;
      case Direction.downRight:
        animation = _walkRightAnimation;
        if (position.y < 32 * 23 - height) {
          position.y += 25;
        }
        position.x += 5;
        break;
    }
  }
}
