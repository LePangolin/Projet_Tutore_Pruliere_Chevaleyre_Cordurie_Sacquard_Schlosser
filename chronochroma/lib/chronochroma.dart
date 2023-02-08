import 'package:chronochroma/components/level.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/player.dart';

class Chronochroma extends FlameGame with HasCollisionDetection {
  final Player player = Player();
  Level? _currentLevel;
  int currentLevelIter = 0;
  final List<String> _allLevelsList = ['map-1.tmx', 'map-2.tmx'];
  SpriteComponent? overlayComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Par précaution, on met le jeu en plein écran et en paysage
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    // On charge la map
    loadLevel();

    // On ajoute le joueur au jeu
    add(player);
  }

  // Influence la direction du joueur
  onArrowKeyChanged(Direction direction) {
    player.direction = direction;
  }

  void loadLevel() {
    // Si on a déjà une map, on la supprime
    _currentLevel?.removeFromParent();
    // On charge la map à venir
    _currentLevel =
        Level(_allLevelsList[currentLevelIter % _allLevelsList.length]);
    // On ajoute la map au jeu
    add(_currentLevel!);
    // On attend que la map soit chargée
    _currentLevel!.load().then((_) async {
      // On place le joueur au spawn
      player.teleport(_currentLevel!.spawnPoint);
      // On suit le joueur en respectant les limites de la map
      camera.followComponent(player,
          worldBounds: Rect.fromLTRB(
              0, 0, _currentLevel!.level.size.x, _currentLevel!.level.size.y));

      // On fixe une résolution qui s'adapte à l'écran
      camera.viewport = FixedResolutionViewport(Vector2(1600, 900));

      // On fixe le zoom initial de la caméra
      camera.zoom = 1.75;

      // On ajoute le composant de transition entre les niveaux
      overlayComponent?.removeFromParent();
      overlayComponent = SpriteComponent(
          sprite: await loadSprite('fadeBackground.jpg'),
          paint: Paint()..color = const Color.fromARGB(0, 0, 0, 0),
          priority: 1000);
      add(overlayComponent!);

      // On replace le joueur de la map et en dessous de la transition
      player.priority = 999;

      // On augmente le numéro du niveau pour le prochain chargement
      currentLevelIter++;
    });
  }

  void sendPlayerToSpawn() {
    player.teleport(_currentLevel!.spawnPoint);
  }
}
