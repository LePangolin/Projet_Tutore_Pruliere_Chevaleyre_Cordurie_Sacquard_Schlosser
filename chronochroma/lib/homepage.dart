import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/compte.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Compte? compte;

  late String pass;

  late String pseudo;

  late bool result;

  bool notConnected = true;

  @override
  void initState() {
    super.initState();
    _loadCompte();
  }

  Future<void> _loadCompte() async {
    compte = await Compte.getInstance();
    if (compte == null) {
      setState(() {
        notConnected = true;
      });
    } else {
      setState(() {
        notConnected = false;
      });
    }
  }

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
        child: Stack(children: [
          Column(
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
              ),
            ],
          ),
          notConnected
              ? Positioned(
                  bottom: 10,
                  right: 15,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(13)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0),
                                side: const BorderSide(color: Colors.white)))),
                    child: const Text('Connexion',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Connexion'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                        labelText: 'Pseudo'),
                                    onChanged: (String value) {
                                      pseudo = value;
                                    },
                                  ),
                                  TextField(
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        labelText: 'Mot de passe'),
                                    onChanged: (String value) {
                                      pass = value;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          result = await Compte.connexion(
                                              pseudo, pass);
                                          if (result) {
                                            Navigator.pop(context);
                                            _loadCompte();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Erreur de connexion')));
                                          }
                                        },
                                        child: const Text("Se connecter")),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                )
              : Positioned(
                  bottom: 10,
                  right: 15,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      side: const BorderSide(
                                          color: Colors.white)))),
                      child: const Text('Deconnexion',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      onPressed: () async {
                        result = await Compte.deconnexion();
                        if (result) {
                          setState(() {
                            notConnected = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Erreur de deconnexion')));
                        }
                      }),
                ),
        ]),
      ),
    );
  }
}
