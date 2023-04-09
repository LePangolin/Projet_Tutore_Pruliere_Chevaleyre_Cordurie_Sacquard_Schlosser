import 'package:chronochroma/chronochroma.dart';
import 'package:chronochroma/components/map/barrel.dart';
import 'package:chronochroma/components/map/coin.dart';
import 'package:chronochroma/components/map/fire_trap.dart';
import 'package:chronochroma/components/entities/bat.dart';
import 'package:chronochroma/components/entities/skeleton.dart';
import 'package:chronochroma/components/map/next_level_door.dart';
import 'package:chronochroma/components/map/portal_teleport_spawn.dart';
import 'package:chronochroma/components/map/unstable_floor.dart';
import 'package:chronochroma/components/map/upward_teleport.dart';
import 'package:chronochroma/components/map/void_teleport_spawn.dart';
import 'package:chronochroma/components/map/world_collides.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends Component with HasGameRef<Chronochroma> {
  final String name;
  late Vector2 spawnPoint = Vector2.zero();
  late TiledComponent level;

  Level(this.name) : super();

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
      for (final object in worldLayer.objects) {
        add(WorldCollides(
          size: Vector2(object.width, object.height),
          position: Vector2(object.x, object.y),
        ));
      }
    }

// Récupère la layer des sols instables
    final unstableFloorLayer =
        level.tileMap.getLayer<ObjectGroup>('unstableFloors');
    if (unstableFloorLayer != null) {
      for (final object in unstableFloorLayer.objects) {
        add(UnstableFloor(object));
      }
    }

// Récupère la layer des portes de changement de niveau
    final nextLevelDoorLayer =
        level.tileMap.getLayer<ObjectGroup>('nextLevelDoor');
    if (nextLevelDoorLayer != null) {
      for (final object in nextLevelDoorLayer.objects) {
        add(NextLevelDoor(object));
      }
    }

// Récupère la layer des téléporteurs
    final teleporters = level.tileMap.getLayer<ObjectGroup>('teleporters');
    if (teleporters != null) {
      for (final object in teleporters.objects) {
        add(TeleportSpawnPortal(object));
      }
    }

    final upwardTeleport =
        level.tileMap.getLayer<ObjectGroup>('upwardTeleport');
    if (upwardTeleport != null) {
      for (final object in upwardTeleport.objects) {
        add(UpwardTeleport(object));
      }
    }

    // Récupère la layer void
    final voidTeleport = level.tileMap.getLayer<ObjectGroup>('void');
    if (voidTeleport != null) {
      for (final object in voidTeleport.objects) {
        add(VoidTeleportSpawn(object));
      }
    }

// Récupère la layer des monstres
    final bat = level.tileMap.getLayer<ObjectGroup>('bat');
    if (bat != null) {
      for (final object in bat.objects) {
        add(Bat(object));
      }
    }

    final skeleton = level.tileMap.getLayer<ObjectGroup>('skeleton');
    if (skeleton != null) {
      for (final object in skeleton.objects) {
        add(Skeleton(object));
      }
    }

    // Récupère la layer des caisses
    final barrelLayer = level.tileMap.getLayer<ObjectGroup>('barrels');
    if (barrelLayer != null) {
      for (final object in barrelLayer.objects) {
        if (gameRef.pseudoRandomNG.getBoolean(1, 3)) {
          add(Barrel(object));
        }
      }
    }

    // Récupère la layer des pièces
    final coins = level.tileMap.getLayer<ObjectGroup>('coins');
    if (coins != null) {
      for (final object in coins.objects) {
        if (gameRef.pseudoRandomNG.getBoolean(3, 4)) {
          add(Coin(object));
        }
      }
    }

    // Récupère la layer des pièces
    final traps = level.tileMap.getLayer<ObjectGroup>('traps');
    if (traps != null) {
      for (final object in traps.objects) {
        if (gameRef.pseudoRandomNG.getBoolean(1, 2)) {
          add(FireTrap(object));
        }
      }
    }

    return super.onLoad();
  }

  void addObject(dynamic obj) {
    add(obj);
  }
}
