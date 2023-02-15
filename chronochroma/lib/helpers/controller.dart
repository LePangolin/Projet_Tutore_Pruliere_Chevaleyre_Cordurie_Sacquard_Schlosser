import 'package:flutter/material.dart';
import 'directions.dart';
import './joysticks.dart';

class Controller extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;

  const Controller({Key? key, required this.onDirectionChanged})
      : super(key: key);

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  Direction _direction = Direction.none;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20),
        child: SizedBox(
            height: 150,
            width: 150,
            child: Column(
              children: [
                Joystick(
                  up: () {
                    _direction = Direction.up;
                    widget.onDirectionChanged!(_direction);
                  },
                  down: () {
                    _direction = Direction.down;
                    widget.onDirectionChanged!(_direction);
                  },
                  left: () {
                    _direction = Direction.left;
                    widget.onDirectionChanged!(_direction);
                  },
                  right: () {
                    _direction = Direction.right;
                    widget.onDirectionChanged!(_direction);
                  },
                  none: () {
                    _direction = Direction.none;
                    widget.onDirectionChanged!(_direction);
                  },
                  upLeft: () {
                    _direction = Direction.upLeft;
                    widget.onDirectionChanged!(_direction);
                  },
                  upRight: () {
                    _direction = Direction.upRight;
                    widget.onDirectionChanged!(_direction);
                  },
                  downLeft: () {
                    _direction = Direction.downLeft;
                    widget.onDirectionChanged!(_direction);
                  },
                  downRight: () {
                    _direction = Direction.downRight;
                    widget.onDirectionChanged!(_direction);
                  },
                ),
              ],
            )));
  }
}
