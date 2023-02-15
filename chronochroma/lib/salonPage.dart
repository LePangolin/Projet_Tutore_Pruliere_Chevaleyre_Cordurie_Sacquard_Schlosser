import 'dart:developer';

import 'package:chronochroma/components/compte.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  List<String> imageFormat = [
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".bmp",
    ".webp",
    ".ico"
  ];

  @override
  void initState() {
    super.initState();
    _loadCompte();
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
                                          onPressed: () {
                                            Compte.deconnexion();
                                            setState(() {
                                              isConnected = false;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text("Déconnexion",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () async {
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
                      backgroundImage: NetworkImage(url!),
                    ),
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
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Connexion'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration:
                                    const InputDecoration(labelText: 'Pseudo'),
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
                                      result =
                                          await Compte.connexion(pseudo, pass);
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
            ),
          Positioned(
              bottom: -20,
              left: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                height: 150,
                child: IconButton(
                    icon: Image.asset('assets/images/button_scores.png'),
                    onPressed: () => {_launchURL()}),
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
                    onPressed: () =>
                        {Navigator.popAndPushNamed(context, '/upgrade')}),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                height: 150,
                child: IconButton(
                    icon: Image.asset('assets/images/button_jouer.png'),
                    onPressed: () =>
                        {Navigator.popAndPushNamed(context, '/game')}),
              )
            ]),
          )
        ]),
      ),
    );
  }

  Future<void> _launchURL() async {
    Uri url = Uri.parse("https://chronochroma.alwaysdata.net/wordpress/");
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
