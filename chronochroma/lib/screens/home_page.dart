import 'dart:async';
import 'package:chronochroma/components/signIn.dart';
import 'package:chronochroma/components/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/compte.dart';
import 'package:audioplayers/audioplayers.dart';

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

  bool? _ableToReachInternet;

  bool insciptionTab = false;

  SnackBar snack = const SnackBar(
      content: Text(
          "Vous n'êtes pas connecté à internet, aucune modification ne sera sauvegardée."),
      duration: Duration(seconds: 15));

  bool snackshow = false;

  @override
  void initState() {
    super.initState();
    _loadCompte();
    _checkInternetConnectivity();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkInternetConnectivity();
    });
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

  Future<void> _checkInternetConnectivity() async {
    _ableToReachInternet = await Compte.checkConnexion();
    if (mounted) {
      if (_ableToReachInternet!) {
        if (snackshow) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          snackshow = false;
        }
      } else {
        if (!snackshow) {
          ScaffoldMessenger.of(context).showSnackBar(snack);
          snackshow = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
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
                          player.play(AssetSource('audio/interface_click.wav'));
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
                      modalConnexion();
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

  void modalConnexion() async {
    String title = insciptionTab ? 'Inscription' : 'Connexion';
    String inkwellText = insciptionTab
        ? 'Déjà un compte ? Connectez-vous'
        : 'Pas encore de compte ? Inscrivez-vous';
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: AlertDialog(
                  title: Text(title),
                  content: Container(
                    child: Column(
                      children: [
                        !insciptionTab
                            ? SignIn(update: (bool result) {
                                setState(() {
                                  _loadCompte();
                                });
                              })
                            : signup(update: (bool result) {
                                setState(() {
                                  _loadCompte();
                                });
                              }),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            child: Text(inkwellText),
                            onTap: () async {
                              setState(() {
                                insciptionTab = !insciptionTab;
                              });
                              Navigator.pop(context);
                              modalConnexion();
                              SystemChrome.setEnabledSystemUIOverlays([]);
                            },
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }
}
