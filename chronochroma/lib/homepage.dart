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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_1.png'),
              fit: BoxFit.cover,
              scale: 2.0,
            ),
          ),
          // add a image on top of joystick which will move according to joystick movement
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
              margin: const EdgeInsets.only(top: 40),
              child: Image(
                image: const AssetImage('assets/images/logoMEILLEUREVER.png'),
                width: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      icon: Image.asset('assets/images/button_commencer.png'),
                      iconSize: MediaQuery.of(context).size.width * 0.2,
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/salon');
                      },
                    ),
                  ),
                ],
              ),
            )
            ],
          )),

    );
  }
}
