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
  double gravity = 1.2;
  Vector2 velocity = Vector2(0, 0);
  Direction direction = Direction.none;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkLeftAnimation;
  late final SpriteAnimation _walkRightAnimation;
  bool isCollided = false;
  List lastDirection = [];

  // Vitesse d'animation : plus c'est haut, plus c'est lent
  final double _idleAnimationSpeed = 0.25;
  final double _walkAnimationSpeed = 0.1;

  Player() : super(size: Vector2.all(75)) {
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
    print(lastDirection);
    if (!lastDirection.contains("down")) {
      print("here");
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
        if(isCollided && lastDirection.contains('up')){
          position.y -=0;
        } else {
          animation = _walkRightAnimation;
          position.y -= 15;
        }
        break;
      case Direction.down:
        if(isCollided && lastDirection.contains('down')){
          position.y +=0;
        } else {
          animation = _walkLeftAnimation;
            position.y += 10;
        }
        break;
      case Direction.left:
        if(isCollided && lastDirection.contains('left')){
          position.x -=0;
        } else {
          animation = _walkLeftAnimation;
          position.x -= 5;
        }
        break;
      case Direction.right:
        if(isCollided && lastDirection.contains('right')){
          position.x +=0;
        } else {
          animation = _walkRightAnimation;
          position.x += 5;
        }
        break;
      case Direction.none:
        animation = _idleAnimation;
        break;
      // case Direction.upLeft:
      //   animation = _walkLeftAnimation;
      //   position.y -= 15;
      //   position.x -= 5;
      //   break;
      // case Direction.upRight:
      //   animation = _walkRightAnimation;
      //   position.y -= 15;
      //   position.x += 5;
      //   break;
      // case Direction.downLeft:
      //   animation = _walkLeftAnimation;
      //     position.y += 25;
      //     position.x -= 5;
      //   break;
      // case Direction.downRight:
      //   animation = _walkRightAnimation;
      //     position.y += 25;
      //     position.x += 5;
      //   break;
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
}




