import 'dart:math';

import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/barrel.dart';
import 'package:chronochroma/components/monster.dart';
import 'package:chronochroma/components/skeleton.dart';
import 'package:chronochroma/components/nextLevelDoor.dart';
import 'package:chronochroma/components/TeleportSpawnPortal.dart';
import 'package:chronochroma/components/unstableFloor.dart';
import 'package:chronochroma/components/worldCollides.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends Component with HasGameRef<Chronochroma> {
  final String name;
  late Vector2 spawnPoint = Vector2.zero();
  late TiledComponent level;

  int randomI = 1;
  int randomJ = 2;

  Level(this.name) : super();

  @override
  Future<void> load() async {
    level = await TiledComponent.load(name, Vector2.all(32));
    add(level);

    // Récupère la layer PlayerSpawnPoint et les coordonnées du spawn
    for (final spawn
        in level.tileMap.getLayer<ObjectGroup>('playerspawnpoint')!.objects) {
      spawnPoint = Vector2(spawn.x, spawn.y);
    }

// Récupère la layer du sol, des murs
    final worldLayer = level.tileMap.getLayer<ObjectGroup>('ground');
    if (worldLayer != null) {
      for (final object in worldLayer!.objects) {
        add(WorldCollides(
          size: Vector2(object.width, object.height),
          position: Vector2(object.x, object.y),
        ));
      }
    }

// Récupère la layer des caisses
    final barrelLayer = level.tileMap.getLayer<ObjectGroup>('barrels');
    if (barrelLayer != null) {
      for (final object in barrelLayer!.objects) {
        if (gameRef.pseudoRandomNG.getBoolean(1, 3)) {
          add(Barrel(object));
        }
      }
    }

// Récupère la layer des sols instables
    final unstableFloorLayer =
        level.tileMap.getLayer<ObjectGroup>('unstableFloors');
    if (unstableFloorLayer != null) {
      for (final object in unstableFloorLayer!.objects) {
        add(UnstableFloor(object));
      }
    }

// Récupère la layer des portes de changement de niveau
    final nextLevelDoorLayer =
        level.tileMap.getLayer<ObjectGroup>('nextLevelDoor');
    if (nextLevelDoorLayer != null) {
      for (final object in nextLevelDoorLayer!.objects) {
        add(NextLevelDoor(object));
      }
    }

// Récupère la layer des téléporteurs
    final teleporters = level.tileMap.getLayer<ObjectGroup>('teleporters');
    if (teleporters != null) {
      for (final object in teleporters!.objects) {
        add(TeleportSpawnPortal(object));
      }
    }

// Récupère la layer des monstres
    final bebou = level.tileMap.getLayer<ObjectGroup>('bebou');
    if (bebou != null) {
      for (final object in bebou!.objects) {
        add(Monster(object));
      }
    }

    final squelette = level.tileMap.getLayer<ObjectGroup>('squelette');
    if (squelette != null) {
      for (final object in squelette!.objects) {
        add(Skeleton(object));
      }
    }

    return super.onLoad();
  }

  void addObject(dynamic obj) {
    add(obj);
  }
}
