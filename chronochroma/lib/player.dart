import 'dart:developer';
import 'dart:math';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/worldCollides.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {

  // Attributs de direction et d'animation
  double gravity = 1;
  Vector2 velocity = Vector2(0, 0);
  Direction direction = Direction.none;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _crouchAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _slideAnimation;
  bool isCollided = false;
  List lastDirection = [];

  // Vitesse d'animation : plus c'est haut, plus c'est lent
  final double _idleAnimationSpeed = 0.25;
  final double _crouchAnimationSpeed = 0.25;
  final double _jumpAnimationSpeed = 0.25;
  final double _runAnimationSpeed = 0.08;
  final double _slideAnimationSpeed = 0.12;

  final double _xMoveSpeed = 5;
  final double xVelocityMax = 15;
  final double yVelocityMax = 10;

  bool facingRight = true;

  Player() : super(size: Vector2(256, 128), anchor: Anchor.center) {}

  late RectangleHitbox topHitBox;
  late RectangleHitbox bottomHitBox;
  late RectangleHitbox frontHitBox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _idleAnimation});
    position = Vector2(690, 500);

    topHitBox = (RectangleHitbox(
      size: Vector2(32, 30),
      position: Vector2(256 / 2 - 16, 16),
    ));
    bottomHitBox = (RectangleHitbox(
      size: Vector2(32, 30),
      position: Vector2(256 / 2 - 16, 98),
    ));
    frontHitBox = (RectangleHitbox(
      size: Vector2(32, 80),
      position: Vector2(256 / 2 + 16, 32),
    ));

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
    if (velocity.y.abs() < yVelocityMax && !bottomHitBox.isColliding) {
      velocity.y += gravity;
    }

    int i = 0;
    while (!frontHitBox.isColliding && i < velocity.x.abs()) {
      if (facingRight) {
        position.x += 1;
      } else {
        position.x -= 1;
      }
      i++;
      frontHitBox.update(1);
    }

    int j = 0;
    while (j < velocity.y.abs()) {
      if (velocity.y > 0 && !bottomHitBox.isColliding) {
        position.y += 1;
      } else if (velocity.y < 0 && !topHitBox.isColliding) {
        position.y -= 1;
      }
      j++;
      bottomHitBox.update(1);
      topHitBox.update(1);
    }

    velocity.x = 0;

    updatePosition();
  }

// Déplacement du personnage et animation correspondante
  updatePosition() {
    switch (direction) {
      case Direction.up:
        animation = _jumpAnimation;
        if (!topHitBox.isColliding && velocity.y.abs() < yVelocityMax) {
          velocity.y = -_xMoveSpeed;
        }
        break;
      case Direction.down:
        animation = _crouchAnimation;
        velocity.x = 0;
        if (!bottomHitBox.isColliding) {
          velocity.y = _xMoveSpeed / 2;
        }
        break;
      case Direction.left:
        animation = _runAnimation;
        if (!frontHitBox.isColliding && !facingRight) {
          velocity.x = -_xMoveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
       
      case Direction.right:
        animation = _runAnimation;
        if (!frontHitBox.isColliding && facingRight) {
          velocity.x = _xMoveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
        
        
      case Direction.upLeft:
        animation = _jumpAnimation;
        if (!topHitBox.isColliding) {
          velocity.y = -_xMoveSpeed;
        }
        if (!frontHitBox.isColliding && !facingRight) {
          velocity.x = -_xMoveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.upRight:
        animation = _jumpAnimation;
        if (!topHitBox.isColliding) {
          velocity.y = -_xMoveSpeed;
        }
        if (!frontHitBox.isColliding && facingRight) {
          velocity.x = _xMoveSpeed;
        }
        break;
      case Direction.downLeft:
        animation = _slideAnimation;
        if (!bottomHitBox.isColliding) {
          velocity.y = _xMoveSpeed / 8;
        }
        if (!frontHitBox.isColliding && !facingRight) {
          velocity.x = -_xMoveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.downRight:
        animation = _slideAnimation;
        if (!bottomHitBox.isColliding) {
          velocity.y = _xMoveSpeed / 8;
        }
        if (!frontHitBox.isColliding && facingRight) {
          velocity.x = _xMoveSpeed;
        } else {
          velocity.x = 0;
        }
        break;
      case Direction.none:
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
        //TODO print("player center : ${position.x} ${position.y}");

        if (topHitBox.isColliding) {
          //print("top hit");
          // get highest intersection point
          var highestPoint = intersectionPoints
              .reduce((curr, next) => curr.y < next.y ? curr : next);
          // get the y value of the lowest point of other
          var lowestPoint = other.position.y + other.size.y;
          // get the difference between the two
          var diff = lowestPoint - highestPoint.y;
          //TODO print("topPlayer - bottomPoint : ${highestPoint.y} - $lowestPoint");
          //TODO print("diff : $diff");
          // move the player up by the difference
          // position.y += diff;
        }
        if (bottomHitBox.isColliding) {
          //print("bottom hit");
          // get lowest intersection point
          var lowestPoint = intersectionPoints
              .reduce((curr, next) => curr.y > next.y ? curr : next);
          // get the y value of the highest point of other
          var highestPoint = other.position.y;
          // get the difference between the two
          var diff = highestPoint - lowestPoint.y;
          //TODO print("bottomPlayer - topPoint : ${lowestPoint.y} - $highestPoint");
          //TODO print("diff : $diff");
          // move the player down by the difference
          // position.y += diff;
        }
        if (frontHitBox.isColliding) {
          //print("front hit");
          // TODO comme les autres ? Pas évident il faut vérifier la direction

        }

        showme = false;
        Future.delayed(Duration(milliseconds: 1), () {
          showme = true;
        });
      }
    }
  }
}




