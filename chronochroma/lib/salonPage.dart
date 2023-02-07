import 'package:flutter/material.dart';

class SalonPage extends StatefulWidget {
  const SalonPage({super.key, required this.title});

  final String title;

  @override
  State<SalonPage> createState() => _SalonPageState();
}

class _SalonPageState extends State<SalonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_1.png'),
          fit: BoxFit.cover,
          scale: 2.0,
        ),
      ),
      // add a image on top of joystick which will move according to joystick movement
      child: Stack(children: [
        Positioned(
            top: 20,
            left: 20,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://source.unsplash.com/50x50/?portrait',
              ),
            )),
        Positioned(
          bottom: 20,
          left: 20,
          child: ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '');
              },
              child: const Text("Tableau des scores")),
        ),
        Positioned(
          bottom: 20,
          right: 100,
          child: ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/upgrade');
              },
              child: const Text("Améliorations")),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/game');
              },
              child: const Text("Jouer")),
        ),
      ]),
    ));
  }
}