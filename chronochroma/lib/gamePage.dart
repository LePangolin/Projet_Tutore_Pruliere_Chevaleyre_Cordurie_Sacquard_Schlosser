import 'package:chronochroma/overlays/controll.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../chronochroma.dart';
import './helpers/controller.dart';
import 'overlays/gameOver.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Chronochroma game;
  late Widget gameWidget;

  @override
  void initState() {
    super.initState();
    game = Chronochroma();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [        
          GameWidget(
            game: game,
            overlayBuilderMap: {
              gameOver.ID: (BuildContext context, Chronochroma game) =>
                  gameOver(gameRef: game),
              Controll.ID: (BuildContext context, Chronochroma game) =>
                  Controll(gameRef: game)
            },
            Align(
            alignment: Alignment.bottomLeft,
            child: Controller(
              onDirectionChanged: game.onArrowKeyChanged,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(children: [
              IconButton(
                  icon: Image.asset('assets/images/icon/swordIcon.png'),
                  iconSize: 100,
                  onPressed: () => {
                        if (game.player.canAttack)
                          {game.player.isAttacking = true, print('attaque')}
                        else
                          {print('attaque impossible')}
                      }),
              IconButton(
                  icon: Image.asset('assets/images/icon/jumpIcon.png'),
                  iconSize: 100,
                  onPressed: () => {
                        if (game.player.canJump)
                          {
                            game.player.isJumping = true,
                            game.player.canJump = false,
                            print("Jump, jump, jump, everybody jump !")
                          }
                        else
                          {print('saut impossible')}
                      }),
            ]),
            
            
          ),
        ],
      ),
    );
  }
}
