import 'dart:developer';
import 'dart:math';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/worldCollides.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  // Attributs de direction et d'animation
  double gravity = 1.015;
  Vector2 velocity = Vector2(0, 0);
  Direction direction = Direction.none;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _crouchAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _slideAnimation;

  // Vitesse d'animation : plus c'est haut, plus c'est lent
  final double _idleAnimationSpeed = 0.25;
  final double _crouchAnimationSpeed = 0.25;
  final double _jumpAnimationSpeed = 0.25;
  final double _runAnimationSpeed = 0.08;
  final double _slideAnimationSpeed = 0.12;

  final double _moveSpeed = 4;
  final double jumpMultiplier = 1.7;
  final double downMultiplier = 0.5;
  final double xVelocityMax = 10;
  final double yVelocityMax = 15;
  double fallingVelocity = 0;

  final RectangleHitbox topHitBoxStandModel = (RectangleHitbox(
    size: Vector2(28, 30),
    position: Vector2(256 / 2 - 12, 16),
  ));
  final RectangleHitbox frontHitBoxStandModel = (RectangleHitbox(
    size: Vector2(24, 76),
    position: Vector2(256 / 2 + 16, 36),
  ));
  final RectangleHitbox bottomHitBoxStandModel = (RectangleHitbox(
    size: Vector2(28, 30),
    position: Vector2(256 / 2 - 12, 98),
  ));

  final RectangleHitbox topHitBoxSlideModel = (RectangleHitbox(
    size: Vector2(28, 30),
    position: Vector2(256 / 2 - 12, 48),
  ));
  final RectangleHitbox frontHitBoxSlideModel = (RectangleHitbox(
    size: Vector2(24, 40),
    position: Vector2(256 / 2 + 16, 68),
  ));
  final RectangleHitbox bottomHitBoxSlideModel = (RectangleHitbox(
    size: Vector2(28, 30),
    position: Vector2(256 / 2 - 12, 98),
  ));

  bool facingRight = true;
  bool canJump = true;

  Player() : super(size: Vector2(256, 128), anchor: Anchor.center) {}

  late RectangleHitbox topHitBox;
  late RectangleHitbox frontHitBox;
  late RectangleHitbox bottomHitBox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _idleAnimation});
    position = Vector2(15, -100);

    topHitBox = RectangleHitbox(
      size: topHitBoxStandModel.size,
      position: topHitBoxStandModel.position,
    );
    frontHitBox = RectangleHitbox(
      size: frontHitBoxStandModel.size,
      position: frontHitBoxStandModel.position,
    );
    bottomHitBox = RectangleHitbox(
      size: bottomHitBoxStandModel.size,
      position: bottomHitBoxStandModel.position,
    );

    topHitBox.debugMode = true;
    topHitBox.debugColor = Colors.red;
    bottomHitBox.debugMode = true;
    bottomHitBox.debugColor = Colors.red;
    frontHitBox.debugMode = true;
    frontHitBox.debugColor = Colors.orange;

    add(topHitBox);
    add(bottomHitBox);
    add(frontHitBox);
  }

// Animations correspondantes à des états pour le personnage
  Future<void> _loadAnimations() async {
    final idleSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('character/Idle.png'),
        columns: 2,
        rows: 4);
    final crouchSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('character/crouch_idle.png'),
        columns: 2,
        rows: 4);
    final jumpSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('character/Jump.png'),
        columns: 2,
        rows: 4);
    final runSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('character/Run.png'),
      columns: 2,
      rows: 4,
    );
    final slideSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await gameRef.images.load('character/Slide.png'),
      columns: 4,
      rows: 3,
    );

    _idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: _idleAnimationSpeed, from: 0, to: 7);

    _crouchAnimation = crouchSpriteSheet.createAnimation(
        row: 0, stepTime: _crouchAnimationSpeed, from: 0, to: 7);

    _jumpAnimation = jumpSpriteSheet.createAnimation(
        row: 0, stepTime: _jumpAnimationSpeed, from: 0, to: 7);

    _runAnimation = runSpriteSheet.createAnimation(
        row: 0, stepTime: _runAnimationSpeed, from: 0, to: 7);

    _slideAnimation = slideSpriteSheet.createAnimation(
        row: 0, stepTime: _slideAnimationSpeed, from: 0, to: 9);
  }

// dt pour delta time, c'est le temps de raffraichissement
  @override
  void update(double dt) async {
    super.update(dt);
    // Gestion de la direction du sprite personnage
    if (facingRight &&
        (direction == Direction.left ||
            direction == Direction.upLeft ||
            direction == Direction.downLeft)) {
      flipHorizontallyAroundCenter();
      facingRight = false;
    } else if (!facingRight &&
        (direction == Direction.right ||
            direction == Direction.upRight ||
            direction == Direction.downRight)) {
      flipHorizontallyAroundCenter();
      facingRight = true;
    }

    // Augmente la vitesse de chute si le personnage n'est pas sur le sol, sinon annule la vitesse de chute
    if (!bottomHitBox.isColliding) {
      if (fallingVelocity > gravity * 1.5) {
        fallingVelocity *= gravity;
      } else {
        fallingVelocity += gravity * 1.5;
      }
      if (velocity.y + fallingVelocity < yVelocityMax) {
        velocity.y += fallingVelocity;
      } else {
        velocity.y = yVelocityMax;
      }
    } else {
      fallingVelocity = 0;
    }

    //print("Velocity : ${velocity.x} ${velocity.y}");
    int i = 0;
    while (!frontHitBox.isColliding && i < velocity.x.abs()) {
      if (facingRight) {
        position.x += 1;
      } else {
        position.x -= 1;
      }
      i++;
    }

    int j = 0;
    while (j < velocity.y.abs()) {
      if (velocity.y > 0 && !bottomHitBox.isColliding) {
        position.y += 1;
      } else if (velocity.y < 0 && !topHitBox.isColliding) {
        position.y -= 1;
      }
      j++;
    }

    velocity.x = 0;
    velocity.y = 0;
    print("canJump : $canJump");

    updatePosition();
  }

// Déplacement du personnage et animation correspondante
  updatePosition() {
    switch (direction) {
      case Direction.up:
        animation = _jumpAnimation;
        reduceHitBox(false);
        if (!topHitBox.isColliding && canJump) {
          velocity.y = -_moveSpeed * jumpMultiplier;
        }
        break;
      case Direction.down:
        animation = _crouchAnimation;
        reduceHitBox(true);
        velocity.x = 0;
        if (!bottomHitBox.isColliding && velocity.y.abs() < yVelocityMax) {
          velocity.y += _moveSpeed * downMultiplier;
        }
        break;
      case Direction.left:
        animation = _runAnimation;
        reduceHitBox(false);
        if (!frontHitBox.isColliding && !facingRight) {
          velocity.x = -_moveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.right:
        animation = _runAnimation;
        reduceHitBox(false);
        if (!frontHitBox.isColliding && facingRight) {
          velocity.x = _moveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.upLeft:
        animation = _jumpAnimation;
        reduceHitBox(false);
        if (!topHitBox.isColliding && canJump) {
          velocity.y = -_moveSpeed * jumpMultiplier;
        }
        if (!frontHitBox.isColliding && !facingRight) {
          velocity.x = -_moveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.upRight:
        animation = _jumpAnimation;
        reduceHitBox(false);
        if (!topHitBox.isColliding && canJump) {
          velocity.y = -_moveSpeed * jumpMultiplier;
        }
        if (!frontHitBox.isColliding && facingRight) {
          velocity.x = _moveSpeed;
        }
        break;
      case Direction.downLeft:
        animation = _slideAnimation;
        reduceHitBox(true);
        if (!bottomHitBox.isColliding && velocity.y.abs() < yVelocityMax) {
          velocity.y = _moveSpeed * (downMultiplier / 2);
        }
        if (!frontHitBox.isColliding && !facingRight) {
          velocity.x = -_moveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.downRight:
        animation = _slideAnimation;
        reduceHitBox(true);
        if (!bottomHitBox.isColliding && velocity.y.abs() < yVelocityMax) {
          velocity.y += _moveSpeed * (downMultiplier / 2);
        }
        if (!frontHitBox.isColliding && facingRight) {
          velocity.x = _moveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.none:
        reduceHitBox(false);
        if (!bottomHitBox.isColliding) {
          animation = _jumpAnimation;
        } else {
          animation = _idleAnimation;
        }
        break;
    }
  }

  bool showme = true;
  @override
  void onCollision(intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    if (other is WorldCollides) {
      if (showme) {
        if (topHitBox.isColliding) {
          //print("top hit");
        }
        if (bottomHitBox.isColliding) {
          //print("bottom hit");
        }
        if (frontHitBox.isColliding) {
          //print("front hit");
        }
        showme = false;
        Future.delayed(Duration(milliseconds: 500), () {
          showme = true;
        });
      }
    }
  }

  // Redimensionnement des hitbox du personnage, true pour la version basse, false pour la version haute
  void reduceHitBox(bool bool) {
    if (bool) {
      topHitBox.size = topHitBoxSlideModel.size;
      topHitBox.position = topHitBoxSlideModel.position;
      frontHitBox.size = frontHitBoxSlideModel.size;
      frontHitBox.position = frontHitBoxSlideModel.position;
      bottomHitBox.size = bottomHitBoxSlideModel.size;
      bottomHitBox.position = bottomHitBoxSlideModel.position;
    } else {
      if (!topHitBox.isColliding) {
        topHitBox.size = topHitBoxStandModel.size;
        topHitBox.position = topHitBoxStandModel.position;
        frontHitBox.size = frontHitBoxStandModel.size;
        frontHitBox.position = frontHitBoxStandModel.position;
        bottomHitBox.size = bottomHitBoxStandModel.size;
        bottomHitBox.position = bottomHitBoxStandModel.position;
      }
    }
  }
}
