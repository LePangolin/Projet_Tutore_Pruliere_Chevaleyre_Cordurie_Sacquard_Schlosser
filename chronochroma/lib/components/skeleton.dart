import 'dart:developer';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/attackHitbox.dart';
import 'package:chronochroma/components/skeletonAttackHitbox.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'worldCollides.dart';
import 'package:chronochroma/components/projectile.dart';
import 'package:chronochroma/components/player.dart';

class Skeleton extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  int health = 25;
  bool needUpdate = true;
  final TiledObject skeleton;
  int degat = 3;

  bool facingRight = true;
  bool isHurt = false;
  bool isDead = false;

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _attackAnimation;
  late final SpriteAnimation _deathAnimation;
  late final SpriteAnimation _hurtAnimation;

  final double _idleAnimationSpeed = 0.25;
  final double _attackAnimationSpeed = 0.10;
  final double _deathAnimationSpeed = 0.25;
  final double _hurtAnimationSpeed = 0.10;

  late RectangleHitbox skeletonHitbox;

  Skeleton(this.skeleton) : super(size: Vector2(250, 250));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations().then((_) => {animation = _idleAnimation});
    position = Vector2(skeleton.x, skeleton.y + 90);
    anchor = Anchor.bottomCenter;
    debugMode = true;
    debugColor = Colors.green;

    skeletonHitbox = RectangleHitbox(
        size: Vector2(40, 90),
        position: Vector2(115, 80),
        anchor: Anchor.topLeft);

    print(skeletonHitbox.position);
    priority = 1;
    skeletonHitbox.debugMode = true;
    add(skeletonHitbox);
  }

  Future<void> _loadAnimations() async {
    final idleSpriteSheet = await SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('monsters/skeleton/Idle.png'),
      columns: 4,
      rows: 1,
    );

    final attackSpriteSheet = await SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('monsters/skeleton/Attack.png'),
      columns: 8,
      rows: 1,
    );

    final deathSpriteSheet = await SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('monsters/skeleton/Death.png'),
      columns: 4,
      rows: 1,
    );

    final hurtSpriteSheet = await SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('monsters/skeleton/Hurt.png'),
      columns: 4,
      rows: 1,
    );

    _idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: _idleAnimationSpeed, from: 0, to: 3);

    _attackAnimation = attackSpriteSheet.createAnimation(
        row: 0, stepTime: _attackAnimationSpeed, from: 0, to: 7, loop: false);

    _deathAnimation = deathSpriteSheet.createAnimation(
        row: 0, stepTime: _deathAnimationSpeed, from: 0, to: 3, loop: false);

    _hurtAnimation = hurtSpriteSheet.createAnimation(
        row: 0, stepTime: _hurtAnimationSpeed, from: 0, to: 3, loop: false);
  }

  @override
  void update(double dt) async {
    super.update(dt);

    // faire en sorte que le sprite soit toujours face a la direction du joueur

    if (gameRef.player.x > skeleton.x && !facingRight) {
      flipHorizontallyAroundCenter();
      facingRight = true;
    } else if (gameRef.player.x < skeleton.x && facingRight) {
      flipHorizontallyAroundCenter();
      facingRight = false;
    }

    if (isHurt) {
      animation = _hurtAnimation;
      _hurtAnimation.onComplete = () {
        _hurtAnimation.reset();
        animation = _idleAnimation;
        isHurt = false;
      };
    }
    if (isDead) {
      animation = _deathAnimation;
      skeletonHitbox.removeFromParent();
      _deathAnimation.onComplete = () {
        removeFromParent();
      };
    }

    // le squelette attaque toute les 2 secondes
    if (needUpdate && !isHurt) {
      print("needUpdate");
      needUpdate = false;
      SkeletonAttackHitbox attackHitbox;
      if (!facingRight) {
        attackHitbox = SkeletonAttackHitbox(
            Vector2(110, 70), Vector2(skeleton.x - 120, skeleton.y - 80));
      } else {
        attackHitbox = SkeletonAttackHitbox(
            Vector2(110, 70), Vector2(skeleton.x + 10, skeleton.y - 80));
      }
      animation = _attackAnimation;
      _attackAnimation.onFrame = (frame) {
        if (frame == 5) {
          gameRef.getCurrentLevel()!.addObject(attackHitbox);
        }
      };
      _attackAnimation.onComplete = () {
        print("attack complete");
        _attackAnimation.reset();
        attackHitbox.removeFromParent();
        animation = _idleAnimation;
        Future.delayed(Duration(seconds: 5)).then((_) => {
              needUpdate = true,
              print("salam"),
            });
      };
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      // Si le joueur entre en contact avec le squelette, le joueur prend des degats
      gameRef.player.subirDegat(degat);
    } else if (other is AttackHitbox) {
      // Si le joueur attaque le squelette, le squelette prend des degats
      health -= 5;
      isHurt = true;
      if (health <= 0) {
        // Si le squelette n'a plus de vie, il meurt
        isDead = true;
      }
    }
  }
}
