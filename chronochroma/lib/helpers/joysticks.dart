import 'package:flutter/material.dart';
import 'dart:math';

class Joystick extends StatefulWidget {
  final Function up;
  final Function down;
  final Function left;
  final Function right;
  final Function none;
  final Function upLeft;
  final Function upRight;
  final Function downLeft;
  final Function downRight;

  const Joystick({
    Key? key,
    required this.up,
    required this.down,
    required this.left,
    required this.right,
    required this.none,
    required this.upLeft,
    required this.upRight,
    required this.downLeft,
    required this.downRight,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Alignment alignment = Alignment.center;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {},
      onPanUpdate: (details) {
        // make a 8 direction joystick with 45 degree angle

        // make center of joystick as origin
        var center = details.localPosition - Offset(75, 75);

        // calculate angle of joystick
        var angle = (atan2(center.dy, center.dx) * 180 / pi) + 180;

        // calculate direction

        // 0 - 45
        if (angle >= 0 && angle <= 45) {
          widget.left();
          alignment = const Alignment(-1, 0);
        }

        // 45 - 90
        if (angle >= 45 && angle <= 90) {
          widget.upLeft();
          alignment = Alignment.topLeft;
        }

        // 90 - 135
        if (angle >= 90 && angle <= 135) {
          widget.up();
          alignment = const Alignment(0, -1);
        }

        // 135 - 180
        if (angle >= 135 && angle <= 180) {
          widget.upRight();
          alignment = const Alignment(1, -1);
        }

        // 180 - 225
        if (angle >= 180 && angle <= 225) {
          widget.right();
          alignment = const Alignment(1, 0);
        }

        // 225 - 270
        if (angle >= 225 && angle <= 270) {
          widget.downRight();
          alignment = const Alignment(1, 1);
        }

        // 270 - 315
        if (angle >= 270 && angle <= 315) {
          widget.down();
          alignment = const Alignment(0, 1);
        }

        // 315 - 360
        if (angle >= 315 && angle <= 360) {
          widget.downLeft();
          alignment = const Alignment(-1, 1);
        }

        setState(() {});
      },
      onPanEnd: (details) {
        widget.none();
        alignment = const Alignment(0, 0);
        setState(() {});
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/joystick_background.png'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        // add a image on top of joystick which will move according to joystick movement
        child: Align(
            alignment: alignment,
            child: Container(
              height: 75,
              width: 75,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/joystick_knob.png'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
            )),
      ),
    );
  }
}
