import 'dart:math';

import 'package:chronochroma/components/map/level.dart';
import 'package:chronochroma/helpers/pseudo_random_ng.dart';
import 'package:chronochroma/components/entities/attack_hitbox.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:chronochroma/helpers/directions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/compte.dart';
import 'components/entities/player.dart';
import 'overlays/controll.dart';
import 'overlays/game_over.dart';

class Chronochroma extends FlameGame with HasCollisionDetection {
  final Player player = Player();
  late AttackHitbox attackHitbox;
  late Compte? compte;
  Level? currentLevel;
  int currentLevelIter = 0;
  final List<String> _allLevelsList = [
    'map-6.tmx',
    'map-7.tmx',
    'map-8.tmx',
  ];

  // on vérifie si c'est une seed "custom"
  bool setSeed = false;

  bool send = false;

  int seed;
  late final PseudoRandomNG pseudoRandomNG;
  late List<String> _effectiveLevelList;
  int coins = 0;
  // StopWatch
  late final Stopwatch _stopwatch = Stopwatch();
  bool win = false;

  SpriteComponent? overlayComponent;

  // Constructeur
  Chronochroma({this.seed = 0}) {
    if (seed != 0) {
      setSeed = true;
    } else {
      seed = Random().nextInt(900000) + 100000;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    compte = await Compte.getInstance();

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

  void loadLevel() async {
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
            priority: 10);
        add(overlayComponent!);

        // On replace le joueur au dessus de la map et en dessous de la transition
        player.priority = 5;

        if (currentLevelIter == 1) {
          _stopwatch.start();
        }

        // On augmente le numéro du niveau pour le prochain chargement
        currentLevelIter++;
      });
    } else {
      win = true;
      gameOver();
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
    if (!paused) {
      try {
        super.updateTree(dt);
      } catch (e) {}

      super.update(dt);

      await Future.delayed(const Duration(milliseconds: 16)).then((_) async {
        updateGame(0.016);
      });
    }
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
  }

  void gameOver() async {
    _stopwatch.stop();
    pauseEngine();
    overlays.add(GameOver.ID);
    overlays.remove(Controll.ID);
    player.saturation = 0;
    if (await Compte.getInstance() != null) {
      if (win && !send) {
        int minutes = _stopwatch.elapsed.inMinutes;
        int secondes = _stopwatch.elapsed.inSeconds - minutes * 60;
        bool res = await Compte.sendPartie(
            "${minutes}min ${secondes}sec", seed, setSeed);
      }
    }
  }

  int endGameReward() {
    int levelReward = (currentLevelIter - 2) >= 0 ? (currentLevelIter - 2) : 0;
    return coins + levelReward * 2;
  }

  int chronometerValue() {
    return _stopwatch.elapsed.inSeconds;
  }

  String chronometerMinutesSecondes() {
    int minutes = _stopwatch.elapsed.inMinutes;
    int secondes = _stopwatch.elapsed.inSeconds - minutes * 60;
    return "$minutes minutes et $secondes secondes";
  }
}
