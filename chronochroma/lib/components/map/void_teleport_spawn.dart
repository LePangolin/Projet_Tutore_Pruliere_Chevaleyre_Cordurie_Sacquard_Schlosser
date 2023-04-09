import 'package:chronochroma/components/map/return_spawn_objects.dart';
import 'package:flame_tiled/flame_tiled.dart';

class VoidTeleportSpawn extends ReturnSpawnObjects {
  final TiledObject teleportSpawnPortal;

  VoidTeleportSpawn(this.teleportSpawnPortal) : super(teleportSpawnPortal);
}
