import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_1.png'),
              fit: BoxFit.cover,
              scale: 2.0,
            ),
          ),
          // add a image on top of joystick which will move according to joystick movement
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Align(
                    alignment: const Alignment(0.0, 0.0),
                    child: Container(
                      height: 200,
                      width: 430,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/IllustrationWHT.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40, top: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/salon');
                    },
                    child: const Text("Commencer")),
              ),
            ],
          )),
    );
  }
}
