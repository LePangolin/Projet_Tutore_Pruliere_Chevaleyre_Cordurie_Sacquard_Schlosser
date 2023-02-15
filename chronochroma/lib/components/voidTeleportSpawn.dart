import 'package:chronochroma/components/returnSpawnObjects.dart';
import 'package:flame_tiled/flame_tiled.dart';

class VoidTeleportSpawn extends ReturnSpawnObjects {
  final TiledObject teleportSpawnPortal;

  VoidTeleportSpawn(this.teleportSpawnPortal) : super(teleportSpawnPortal);
}
