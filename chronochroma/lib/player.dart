import 'dart:developer';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'components/worldCollides.dart';

class Player extends SpriteAnimationComponent with HasGameRef<Chronochroma>, CollisionCallbacks {
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

  final double _xMoveSpeed = 4;
  double xVelocityIncrease = 0.03;
  double xVelocityRetake = 0.06;
  double xVelocityReinit = 0.0125;
  final double xVelocityMax = 3;

  Player() : super(size: Vector2(300, 150)) {
    anchor = Anchor.topCenter;
    debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _idleAnimation});
    position = Vector2(100, 100);
    add(RectangleHitbox());
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
    
    if (scale != Vector2(-1, 1) &&
        (direction == Direction.left ||
            direction == Direction.upLeft ||
            direction == Direction.downLeft)) {
      scale = Vector2(-1, 1);
    } else if (scale != Vector2(1, 1) &&
        (direction == Direction.right ||
            direction == Direction.upRight ||
            direction == Direction.downRight)) {
      scale = Vector2(1, 1);
    }

    if (direction == Direction.left) {
      position.x += velocity.x;
    } else if (direction == Direction.right) {
      position.x += velocity.x;
    }

    if (velocity.x.abs() > xVelocityReinit) {
      if (velocity.x > 0) {
        velocity.x -= xVelocityReinit;
      } else if (velocity.x < 0) {
        velocity.x += xVelocityReinit;
      }
    } else {
      velocity.x = 0;
    }

    print(lastDirection);
    if (!lastDirection.contains("down")) {
      print("here");
      if (velocity.y < 20) {
        velocity.y += gravity / 5;
      }
      position.y += velocity.y;
    } else {
      velocity.y = 0;
    }

    updatePosition();
  }

// Déplacement du personnage et animation correspondante
  updatePosition() {
    switch (direction) {
      case Direction.up:
         if(isCollided && lastDirection.contains('up')){
          position.y -=0;
        } else {
          animation = _jumpAnimation;
          position.y -= 10;
        }
        break;
      case Direction.down:
         if(isCollided && lastDirection.contains('down')){
          position.y +=0;
        } else {
          animation = _walkLeftAnimation;
          position.y += 12;
        }
        break;
      case Direction.left:        
         if(isCollided && lastDirection.contains('left')){
          position.x -=0;
        } else {
          animation = _runAnimation;
          position.x -= _xMoveSpeed;
          if (velocity.x >= -xVelocityMax) {
            if (velocity.x > 0) {
              velocity.x -= xVelocityRetake;
            } else {
              velocity.x -= xVelocityIncrease;
            }
          }
        }
        break;
       
      case Direction.right:
        if(isCollided && lastDirection.contains('right')){
          position.x +=0;
        } else {
          animation = _runAnimation;
          position.x += _xMoveSpeed;
          if (velocity.x <= xVelocityMax) {
            if (velocity.x < 0) {
              velocity.x += xVelocityRetake;
            } else {
              velocity.x += xVelocityIncrease;
            }
          }
        }
        break;
        
        
      case Direction.upLeft:
        animation = _jumpAnimation;
        position.y -= 5;
        position.x -= _xMoveSpeed;
        break;
      case Direction.upRight:
        animation = _jumpAnimation;
        position.y -= 5;
        position.x += _xMoveSpeed;
        break;
      case Direction.downLeft:
        animation = _slideAnimation;
        if (position.y < 32 * 23 - height) {
          position.y += 12;
        }
        position.x -= _xMoveSpeed * 1.5;
        break;
      case Direction.downRight:
        animation = _slideAnimation;
        if (position.y < 32 * 23 - height) {
          position.y += 12;
        }
        position.x += _xMoveSpeed * 1.5;
        break;
      case Direction.none:
        if (velocity.y > 0) {
          animation = _jumpAnimation;
        } else {
          animation = _idleAnimation;
        }
        break;
    }
  }
  
  @override
  void onCollision(intersectionPoints, other){
    super.onCollision(intersectionPoints, other);
    if( other is WorldCollides){
      isCollided = true;
      // get the hitbox of the player
      var playerHitbox = this.toRect();

      // get the hitbox of the other object
      var otherHitbox = other.toRect();

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
    if( other is WorldCollides){
      print("collision end");
      isCollided = false;
      lastDirection = [];
    }
  }

  void collisionDetector(Rect playerHitbox, Rect otherHitbox) {

    // get the intersection of the two hitboxes
      var intersection = playerHitbox.intersect(otherHitbox);

      var interactionCenter = intersection.center;
     
      if (interactionCenter.dy < playerHitbox.center.dy) {
        if(!lastDirection.contains("up")){
          lastDirection.add("up");
        }
      }
      if (interactionCenter.dy > playerHitbox.center.dy) {
        if(!lastDirection.contains("down")){
          lastDirection.add("down");
        }
      }
      if (interactionCenter.dx < playerHitbox.center.dx) {
        if(!lastDirection.contains("left")){
          lastDirection.add("left");
        }
      }
      if (interactionCenter.dx > playerHitbox.center.dx) {
        if(!lastDirection.contains("right")){
          lastDirection.add("right");
        }
      }
  
}




