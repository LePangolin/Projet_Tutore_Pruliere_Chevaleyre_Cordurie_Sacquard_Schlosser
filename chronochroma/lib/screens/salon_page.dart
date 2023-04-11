import 'dart:async';

import 'package:chronochroma/components/compte.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/signIn.dart';
import '../components/signup.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

class SalonPage extends StatefulWidget {
  const SalonPage({super.key, required this.title});

  final String title;

  @override
  State<SalonPage> createState() => _SalonPageState();
}

class _SalonPageState extends State<SalonPage> {
  Compte? compte;

  bool isConnected = false;

  String? url;

  String? newUrl;

  late String pass;

  late String pseudo;

  late bool result;

  late bool isImage;

  bool insciptionTab = false;

  String? seed;

  bool _ableToReachInternet = false;

  String lastState = "notConnected";

  List<String> imageFormat = [
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".bmp",
    ".webp",
    ".ico"
  ];

  bool snackshow = false;

  SnackBar snack = const SnackBar(
      content: Text(
          "Vous n'êtes pas connecté à internet, aucune modification ne sera sauvegardée."),
      duration: Duration(seconds: 15));

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
    if (compte != null) {
      url = compte!.avatarUrl;
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> _checkInternetConnectivity() async {
    _ableToReachInternet = await Compte.checkConnexion();
    if (_ableToReachInternet) {
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

  @override
  Widget build(BuildContext context) {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('audio/boa_duvet.wav', volume: 0.5);
    final player = AudioPlayer();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          if (isConnected)
            Positioned(
              top: 20,
              left: 20,
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Options"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                        labelText: 'Nouvelle photo de profil'),
                                    onChanged: (String value) {
                                      newUrl = value;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                          onPressed: () async {
                                            result = await Compte.deconnexion();
                                            if (result) {
                                              setState(() {
                                                isConnected = false;
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Erreur de déconnexion")));
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Déconnexion",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () async {
                                              player.play(AssetSource(
                                                  'interface_click.wav'));
                                              isImage = false;

                                              imageFormat.forEach((element) {
                                                if (newUrl!.contains(element)) {
                                                  isImage = true;
                                                }
                                              });

                                              if (!isImage) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "L'URL doit être une image")));
                                                return;
                                              }

                                              if (newUrl != null) {
                                                result =
                                                    await Compte.updateAvatar(
                                                        newUrl!);
                                                if (result) {
                                                  _loadCompte();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Erreur lors de la mise à jour de l'avatar")));
                                                }
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Valider",
                                                style: TextStyle(
                                                    color: Colors.white)))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                        radius: 30,
                        backgroundImage: !_ableToReachInternet
                            ? Image.asset('assets/images/avatar.png').image
                            : NetworkImage(url!)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      compte!.pseudo!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          else
            Positioned(
              top: 20,
              left: 20,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(13)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            side: const BorderSide(color: Colors.white)))),
                child: const Text('Connexion',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                onPressed: () async {
                  player.play(
                      AssetSource('assets/audio/interface_click.wav'));
                  modalConnexion();
                },
              ),
            ),
          Positioned(
              bottom: -20,
              left: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.195,
                height: 150,
                child: IconButton(
                    icon: Image.asset('assets/images/button_scores.png'),
                    onPressed: () async {
                      player.play(AssetSource(
                          'audio/interface_click.wav'));
                      final url = Uri.parse(
                          'http://serverchronochroma.alwaysdata.net/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Problème lors de la redirection')),
                        );
                      }
                    }),
              )),
          Positioned(
            bottom: -20,
            right: 10,
            child: Row(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.31,
                height: 150,
                child: IconButton(
                    icon: Image.asset('assets/images/button_ameliorations.png'),
                    onPressed: () => {
                          player.play(AssetSource(
                              'audio/interface_click.wav')),
                          Navigator.popAndPushNamed(context, '/upgrade')
                        }),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  height: 150,
                  child: IconButton(
                      icon: Image.asset('assets/images/button_jouer.png'),
                      onPressed: () async {
                        player.play(AssetSource('audio/interface_click.wav'));
                        FlameAudio.bgm.stop();
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Lancer une partie'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: 'Seed (optionnel)'),
                                      onChanged: (String value) {
                                        seed = value;
                                      },
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (seed == null ||
                                                seed!.isEmpty ||
                                                seed == ' ') {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, '/game');
                                            } else {
                                              RegExp regExp =
                                                  RegExp(r'^\d{6}$');
                                              if (!regExp.hasMatch(seed!)) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'La seed doit être un nombre à 6 chiffres')));
                                                return;
                                              }
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, '/game',
                                                  arguments: seed);
                                            }
                                          },
                                          child:
                                              const Text("Lancer la partie")),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }))
            ]),
          )
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
                                print(insciptionTab);
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
