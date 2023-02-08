import 'package:flame/game.dart';
import './chronochroma.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './helpers/controller.dart';

void main() {
  // On crée une instance du jeu
  final game = Chronochroma();
  
  // On s'assure que le binding est initialisé
  WidgetsFlutterBinding.ensureInitialized();
  // On désactive la rotation de l'écran
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) =>
          // On désactive la barre de statut
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []))
      .then((_) => {
            // On lance le jeu
            runApp(MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Stack(
                    children: [
                      GameWidget(game: game),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Controller(
                          onDirectionChanged: game.onArrowKeyChanged,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Image.asset('assets/images/icon/swordIcon.png'),
                          iconSize: 128,
                          onPressed: () => {
                            if (game.player.canAttack) {
                              game.player.isAttacking = true,
                              print('attaque')

                            } else {
                              print('attaque impossible')
                            }
                          }
                      
                        ),
                      ),
                    ],
                  ),
                )))
          });
}
