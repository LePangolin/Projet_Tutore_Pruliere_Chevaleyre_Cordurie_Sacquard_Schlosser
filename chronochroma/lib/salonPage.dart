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
        const Positioned(
            top: 20,
            left: 20,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://source.unsplash.com/50x50/?portrait',
              ),
            )),
        Positioned(
          bottom: -63,
          left: -10,
          child: IconButton(
              icon: Image.asset('assets/images/button_scores.png'),
              iconSize: 200,
              onPressed: () => {
                // TODO: faire apparaitre une page web avec les scores
              }),
        ),
        Positioned(
          bottom: -85,
          right: 180,
          child: IconButton(
              icon: Image.asset('assets/images/button_ameliorations.png'),
              iconSize: 250,
              onPressed: () =>
                  {Navigator.popAndPushNamed(context, '/upgrade')}),
        ),
        Positioned(
          bottom: -60,
          right: -17,
          child: IconButton(
              icon: Image.asset('assets/images/button_jouer.png'),
              iconSize: 200,
              onPressed: () => {Navigator.popAndPushNamed(context, '/game')}),
        )
      ]),
    ));
  }
}
