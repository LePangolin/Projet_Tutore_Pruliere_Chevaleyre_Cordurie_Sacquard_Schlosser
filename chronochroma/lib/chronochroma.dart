import 'dart:math';

import 'package:chronochroma/components/level.dart';
import 'package:chronochroma/pseudoRandomNG.dart';
import 'package:chronochroma/components/attackHitbox.dart';
import 'package:chronochroma/components/level.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/player.dart';
import 'overlays/controll.dart';
import './overlays/gameOver.dart';

class Chronochroma extends FlameGame with HasCollisionDetection {
  final Player player = Player();
  late AttackHitbox attackHitbox;
  Level? currentLevel;
  int currentLevelIter = 0;
  final List<String> _allLevelsList = [
    'map-1.tmx',
    'map-2.tmx',
    'map-3.tmx',
    'map-4.tmx',
    'map-5.tmx',
  ];
  // random betweeen 100000 and 999999
  final int seed = Random().nextInt(900000) + 100000;
  late final PseudoRandomNG pseudoRandomNG;
  late List<String> _effectiveLevelList;
  int coins = 0;
  // StopWatch
  late final Stopwatch _stopwatch = Stopwatch();
  bool win = false;

  SpriteComponent? overlayComponent;

  // constructor

  @override
  Future<void> onLoad() async {
    await super.onLoad();

// keep 3 levels in memory
    _effectiveLevelList = List<String>.from(_allLevelsList)
      ..shuffle(Random(seed))
      ..insert(0, 'nexus.tmx');
    _effectiveLevelList = _effectiveLevelList.take(3).toList();

    pseudoRandomNG = PseudoRandomNG(seed);
    print(seed);
    print(_effectiveLevelList);

    // Par précaution, on met le jeu en plein écran et en paysage
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    // On charge la map
    loadLevel();

    // On ajoute le joueur au jeu
    add(player);

    updateGame(0);

    overlays.add(Controll.ID);
  }

  // Influence la direction du joueur
  onArrowKeyChanged(Direction direction) {
    player.direction = direction;
  }

  void loadLevel() {
    // Si on a déjà une map, on la supprime
    currentLevel?.removeFromParent();
    if (currentLevelIter < _effectiveLevelList.length) {
      // On charge la map à venir
      currentLevel = Level(
          _effectiveLevelList[currentLevelIter % _effectiveLevelList.length]);
      // On ajoute la map au jeu
      add(currentLevel!);
      // On attend que la map soit chargée
      currentLevel!.load().then((_) async {
        // On place le joueur au spawn
        player.teleport(currentLevel!.spawnPoint);
        // On suit le joueur en respectant les limites de la map
        camera.followComponent(player,
            worldBounds: Rect.fromLTRB(
                0, 0, currentLevel!.level.size.x, currentLevel!.level.size.y));

        // On fixe une résolution qui s'adapte à l'écran
        camera.viewport = FixedResolutionViewport(Vector2(1600, 900));

        // On fixe le zoom initial de la caméra
        camera.zoom = 2;

        // On ajoute le composant de transition entre les niveaux
        overlayComponent?.removeFromParent();
        overlayComponent = SpriteComponent(
            sprite: await loadSprite('fadeBackground.jpg'),
            paint: Paint()..color = const Color.fromARGB(0, 0, 0, 0),
            priority: 1000);
        add(overlayComponent!);

        // On replace le joueur au dessus de la map et en dessous de la transition
        player.priority = 1;
        // attackHitbox.priority = 1;

        if (currentLevelIter == 1) {
          _stopwatch.start();
        }

        // On augmente le numéro du niveau pour le prochain chargement
        currentLevelIter++;
      });
    } else {
      gameOver();
      win = true;
    }
  }

  Level? getCurrentLevel() {
    return currentLevel;
  }

  void sendPlayerToSpawn() {
    player.teleport(currentLevel!.spawnPoint);
  }

// dt pour delta time, c'est le temps de raffraichissement
  void updateGame(double dt) async {
    super.updateTree(dt);
    super.update(dt);

    await Future.delayed(Duration(milliseconds: 16)).then((_) async {
      updateGame(0.016);
    });
  }

  @override
  void update(double dt) {
    camera.update(dt);
  }

  @override
  void updateTree(double dt) {
    // super.updateTree(dt);
  }

  void addCoin(int value) {
    coins += value;
    print(coins);
  }

  void gameOver() {
    _stopwatch.stop();
    pauseEngine();
    overlays.add(GameOver.ID);
    overlays.remove(Controll.ID);
  }

  int endGameReward() {
    int levelReward = (currentLevelIter - 1) > -1 ? (currentLevelIter - 1) : 0;
    return coins + levelReward * 2;
  }

  int chronometerValue() {
    return _stopwatch.elapsed.inSeconds;
  }

  String chronometerMinutesSecondes() {
    int minutes = _stopwatch.elapsed.inMinutes;
    int secondes = _stopwatch.elapsed.inSeconds - minutes * 60;
    return "$minutes minutes et ${secondes} secondes";
  }
}
