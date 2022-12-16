import 'package:flutter/material.dart';
import 'dart:math';

class Joystick extends StatefulWidget{
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
  _JoystickState createState() => _JoystickState(
    up: up,
    down: down,
    left: left,
    right: right,
    none: none,
    upLeft: upLeft,
    upRight: upRight,
    downLeft: downLeft,
    downRight: downRight,
  );
}

class _JoystickState extends State<Joystick> {

  final Function up;
  final Function down;
  final Function left;
  final Function right;
  final Function none;
  final Function upLeft;
  final Function upRight;
  final Function downLeft;
  final Function downRight;

  _JoystickState(
      {
      required this.up,
      required this.down,
      required this.left,
      required this.right,
      required this.none,
      required this.upLeft,
      required this.upRight,
      required this.downLeft,
      required this.downRight,
      }
  );


  Alignment alignment = Alignment.center;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        print('onPanStart');
      },
      onPanUpdate: (details) {
        // make a 8 direction joystick with 45 degree angle

        // make center of joystick as origin
        var center = details.localPosition - Offset(50, 50);
        
        // calculate angle of joystick
        var angle = (atan2(center.dy, center.dx) * 180 / pi) + 180;

        // calculate direction

        // 0 - 45
        if (angle >= 0 && angle <= 45) {
          left();
          alignment = const Alignment(-1, 0);
        }

        // 45 - 90
        if (angle >= 45 && angle <= 90) {
          upLeft();
          alignment = Alignment.topLeft;
        }

        // 90 - 135
        if (angle >= 90 && angle <= 135) {
          up();
          alignment = const Alignment(0, -1);
        }

        // 135 - 180
        if (angle >= 135 && angle <= 180) {
          upRight();
          alignment = const Alignment(1, -1);
        }

        // 180 - 225
        if (angle >= 180 && angle <= 225) {
          right();
          alignment = const Alignment(1, 0);
        }

        // 225 - 270
        if (angle >= 225 && angle <= 270) {
          downRight();
          alignment = const Alignment(1, 1);
        }

        // 270 - 315
        if (angle >= 270 && angle <= 315) {
          down();
          alignment = const Alignment(0, 1);
        }

        // 315 - 360
        if (angle >= 315 && angle <= 360) {
          downLeft();
          alignment = const Alignment(-1, 1);
        }

        setState(() {
          print(alignment);
        });


      },
      onPanEnd: (details) {
          none();
          alignment = const Alignment(0, 0);
          setState(() {
            print(alignment);
          });
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/joystick_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        // add a image on top of joystick which will move according to joystick movement
        child: Align(
          alignment: alignment,
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/joystick_knob.png'),
                fit: BoxFit.cover,
              ),
            ),
          )
        ),
      ),
    );
  }
}