import 'dart:developer';
import 'dart:math';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'components/worldCollides.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<Chronochroma>, CollisionCallbacks {
  // Attributs de direction et d'animation
  double gravity = 0.2;
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

  final double _xMoveSpeed = 4;
  // double xVelocityIncrease = 0.03;
  // double xVelocityRetake = 0.06;
  // double xVelocityReinit = 0.0125;
  // final double xVelocityMax = 3;
  final double yVelocityMax = 3;

  bool onGround = false;
  bool facingRight = true;

  Player() : super(size: Vector2(256, 128), anchor: Anchor.bottomCenter) {}

  late RectangleHitbox hitBoxCharacter;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _idleAnimation});
    position = Vector2(690, 500);

    hitBoxCharacter = (RectangleHitbox(
      size: Vector2(64, 128),
      position: Vector2(256 / 2 - 32, 0),
    ));
    hitBoxCharacter.debugMode = true;
    add(hitBoxCharacter);
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
  void update(double dt) {
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

    // Augmente le déplacement du personnage avec la vitesse de course accumulée
    // if (direction == Direction.left || direction == Direction.right) {
    //   if (!isCollided) {
    //     position.x += velocity.x;
    //   }
    // }

    // Diminue la vitesse de course accumulée du personnage
    // if (velocity.x.abs() > xVelocityReinit) {
    //   if (velocity.x > 0) {
    //     velocity.x -= xVelocityReinit;
    //   } else if (velocity.x < 0) {
    //     velocity.x += xVelocityReinit;
    //   }
    // } else {
    //   velocity.x = 0;
    // }

    // Augmente la vitesse de chute si le personnage n'est pas sur le sol, sinon annule la vitesse de chute
    if (!onGround) {
      if (velocity.y < yVelocityMax) {
        velocity.y += gravity;
      }
    } else {
      velocity.y = 0;
    }
    position.x += velocity.x;
    position.y += velocity.y;

    updatePosition();
  }

// Déplacement du personnage et animation correspondante
  updatePosition() {
    switch (direction) {
      case Direction.up:
        animation = _jumpAnimation;
        if (isCollided && lastDirection.contains('up')) {
          velocity.x = 0;

          velocity.y = 0;
        } else {
          velocity.y = -4;
        }
        break;
      case Direction.down:
        animation = _crouchAnimation;
        if (isCollided && lastDirection.contains('down')) {
          velocity.x = 0;
          velocity.y = 0;
        } else {
          velocity.x = 0;
          velocity.y = 12;
        }
        break;
      case Direction.left:
        animation = _runAnimation;

        if (isCollided && lastDirection.contains('left')) {
          velocity.x = 0;
          velocity.y = 0;
        } else {
          velocity.x = -_xMoveSpeed;

          // if (velocity.x >= -xVelocityMax) {
          //   if (velocity.x > 0) {
          //     velocity.x -= xVelocityRetake;
          //   } else {
          //     velocity.x -= xVelocityIncrease;
          //   }
          // }
        }
        break;
      case Direction.right:
        animation = _runAnimation;

        if (isCollided && lastDirection.contains('right')) {
          velocity.x = 0;
        } else {
          velocity.x = _xMoveSpeed;
          // if (velocity.x <= xVelocityMax) {
          //   if (velocity.x < 0) {
          //     velocity.x += xVelocityRetake;
          //   } else {
          //     velocity.x += xVelocityIncrease;
          //   }
          // }
        }
        break;
      case Direction.upLeft:
        animation = _jumpAnimation;
        if (isCollided &&
            (lastDirection.contains('up') || lastDirection.contains('left'))) {
          velocity.x = 0;
          velocity.y = 0;
        } else {
          velocity.x = -_xMoveSpeed;
          velocity.y = -5;
          // if (velocity.x <= xVelocityMax) {
          //   if (velocity.x < 0) {
          //     velocity.x += xVelocityRetake;
          //   } else {
          //     velocity.x += xVelocityIncrease;
          //   }
          // }
        }
        break;
      case Direction.upRight:
        animation = _jumpAnimation;
        if (isCollided &&
            (lastDirection.contains('up') || lastDirection.contains('right'))) {
          velocity.x = 0;
          velocity.y = 0;
        } else {
          velocity.x = _xMoveSpeed;
          velocity.y = -5;
          // if (velocity.x <= xVelocityMax) {
          //   if (velocity.x < 0) {
          //     velocity.x += xVelocityRetake;
          //   } else {
          //     velocity.x += xVelocityIncrease;
          //   }
          // }
        }
        break;
      case Direction.downLeft:
        animation = _slideAnimation;
        if (isCollided && (lastDirection.contains('left'))) {
          velocity.x = 0;
        } else {
          velocity.x = -_xMoveSpeed * 1.3;
          // if (velocity.x <= xVelocityMax) {
          //   if (velocity.x < 0) {
          //     velocity.x += xVelocityRetake;
          //   } else {
          //     velocity.x += xVelocityIncrease;
          //   }
          // }
        }
        break;
      case Direction.downRight:
        animation = _slideAnimation;
        if (isCollided && (lastDirection.contains('right'))) {
          velocity.x = 0;
        } else {
          velocity.x = _xMoveSpeed * 1.3;
          // if (velocity.x <= xVelocityMax) {
          //   if (velocity.x < 0) {
          //     velocity.x += xVelocityRetake;
          //   } else {
          //     velocity.x += xVelocityIncrease;
          //   }
          // }
        }
        break;
      case Direction.none:
        velocity.x = 0;
        if (!onGround) {
          animation = _jumpAnimation;
        } else {
          animation = _idleAnimation;
        }
        break;
    }
  }

  @override
  void onCollision(intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    if (other is WorldCollides) {
      if (velocity.y > 0) {
        onGround = true;
        velocity.y = 0;
      }
      isCollided = true;
      // get the hitbox of the player
      var playerHitbox = hitBoxCharacter.toRect();

      // get the hitbox of the other object
      var otherHitbox = other.toRect();

      //print(lastDirection);

      collisionDetector(playerHitbox, otherHitbox);
    }
  }

  // @override
  // void onCollisionStart(intersectionPoints, other) {
  //   super.onCollisionStart(intersectionPoints, other);
  //   if( other is WorldCollides){
  //     isCollided = true;
  //     // get the hitbox of the player
  //     var playerHitbox = this.toRect();
  //     // get the hitbox of the other object
  //     var otherHitbox = other.toRect();
  //     collisionDetector(playerHitbox, otherHitbox);
  //   }
  // }

  @override
  void onCollisionEnd(other) {
    super.onCollisionEnd(other);
    if (other is WorldCollides) {
      // print("collision end");
      isCollided = false;
      lastDirection = [];
      onGround = false;
    }
  }

  void collisionDetector(Rect playerHitbox, Rect otherHitbox) {
    // get the intersection of the two hitboxes
    var intersection = playerHitbox.intersect(otherHitbox);

    var interactionCenter = intersection.center;

    if (playerHitbox.center.dy > interactionCenter.dy) {
      print("up: ${interactionCenter.dy} < ${playerHitbox.center.dy}");
      if (!lastDirection.contains("up")) {
        lastDirection.add("up");
        if (position.y < otherHitbox.bottom) {
          //position.y = otherHitbox.bottom + 128;
        }
      }
    }
    if (interactionCenter.dy > playerHitbox.center.dy) {
      // print("down: ${interactionCenter.dy} > ${playerHitbox.center.dy}");
      if (!lastDirection.contains("down")) {
        onGround = true;
        lastDirection.add("down");
        if (position.y > otherHitbox.top) {
          print(otherHitbox.top);
          //position.y = otherHitbox.top;
        }
      }
    }
    if (interactionCenter.dx < playerHitbox.center.dx) {
      print("left: ${interactionCenter.dx} < ${playerHitbox.center.dx}");
      if (!lastDirection.contains("left")) {
        lastDirection.add("left");
        if (position.x - 36 < otherHitbox.right) {
          //position.x = otherHitbox.right + 36;
        }
      }
    }
    if (interactionCenter.dx > playerHitbox.center.dx) {
      print("right: ${interactionCenter.dx} > ${playerHitbox.center.dx}");
      if (!lastDirection.contains("right")) {
        lastDirection.add("right");
        print("${position.x + 32} > ${otherHitbox.left}");
        if (position.x + 32 > otherHitbox.left) {
          //position.x = otherHitbox.left - 36;
        }
      }
    }
  }
}
