import 'package:flutter/material.dart';
import './../helpers/controller.dart';
import './../chronochroma.dart';

class Controll extends StatefulWidget {
  final Chronochroma gameRef;
  static const String ID = "controll";

  const Controll({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<Controll> createState() => _ControllState();
}

class _ControllState extends State<Controll> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.bottomLeft,
        child: Controller(
          onDirectionChanged: widget.gameRef.onArrowKeyChanged,
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
            icon: Image.asset('assets/images/icon/swordIcon.png'),
            iconSize: 128,
            onPressed: () => {
                  if (widget.gameRef.player.canAttack)
                    {widget.gameRef.player.isAttacking = true, print('attaque')}
                  else
                    {print('attaque impossible')}
                }),
      ),
    ]);
  }
}
