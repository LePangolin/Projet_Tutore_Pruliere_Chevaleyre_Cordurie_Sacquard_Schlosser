import 'package:flutter/material.dart';
import './compte.dart';

class signup extends StatefulWidget {
  final Function(bool) update;
  const signup({required this.update});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  late String pass;
  late String pseudo;
  late String avatar =
      "http://serverchronochroma.alwaysdata.net/img/avatar.png";
  late bool result;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Pseudo'),
          onChanged: (String value) {
            pseudo = value;
          },
        ),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Mot de passe'),
          onChanged: (String value) {
            pass = value;
          },
        ),
        TextField(
          decoration:
              const InputDecoration(labelText: 'Photo de profil (optionnel)'),
          onChanged: (String value) {
            avatar = value;
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
              onPressed: () async {
                result = await Compte.inscription(pseudo, pass, avatar: avatar);
                widget.update(result);
                if (result) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Erreur de création de compte')));
                }
              },
              child: const Text("Inscription")),
        ),
      ],
    );
  }
}
