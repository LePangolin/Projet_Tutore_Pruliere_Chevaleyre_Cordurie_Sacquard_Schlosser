import 'dart:math';

import 'monster.dart';
import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/barrel.dart';
import 'package:chronochroma/components/nextLevelDoor.dart';
import 'package:chronochroma/components/unstableFloor.dart';
import 'package:chronochroma/components/worldCollides.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends Component with HasGameRef<Chronochroma> {
  final String name;
  late Vector2 spawnPoint = Vector2.zero();
  late TiledComponent level;

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
    for (final object in worldLayer!.objects) {
      add(WorldCollides(
        size: Vector2(object.width, object.height),
        position: Vector2(object.x, object.y),
      ));
    }

// Récupère la layer des caisses
    final barrelLayer = level.tileMap.getLayer<ObjectGroup>('barrels')!.objects;
    for (final object in barrelLayer) {
      if (Random().nextBool()) {
        add(Barrel(object));
      }
    }

// Récupère la layer des sols instables
    final unstableFloorLayer =
        level.tileMap.getLayer<ObjectGroup>('unstableFloors')!.objects;
    for (final object in unstableFloorLayer) {
      add(UnstableFloor(object));
    }

// Récupère la layer des portes de changement de niveau
    final nextLevelDoorLayer =
        level.tileMap.getLayer<ObjectGroup>('nextLevelDoor')!.objects;
    for (final object in nextLevelDoorLayer) {
      add(NextLevelDoor(object));
    }

// Récupère la layer des monstres
    final bebou = level.tileMap.getLayer<ObjectGroup>('bebou')!.objects;
    for (final object in bebou) {
      add(Monster(object));
    }

    return super.onLoad();
  }

  void addObject(dynamic obj) {
    add(obj);
  }
}
