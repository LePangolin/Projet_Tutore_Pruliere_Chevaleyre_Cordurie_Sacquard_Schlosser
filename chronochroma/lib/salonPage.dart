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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          // add a image on top of joystick which will move according to joystick movement
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, '');
                            },
                            child: const Text("Tableau des scores")),
                      ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                      context, '/upgrade');
                                },
                                child: const Text("Améliorations")),
                            SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, '/game');
                                },
                                child: const Text("Jouer")),
                          ]),
                    ]),
              ),
            ],
          )),
    );
  }
}
