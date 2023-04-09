import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "compte.dart";

class SignIn extends StatefulWidget {
  final Function(bool) update;
  const SignIn({Key? key, required this.update}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? pseudo;
  String? pass;
  bool result = false;
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
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
              onPressed: () async {
                result = await Compte.connexion(pseudo!, pass!);
                widget.update(result);
                if (result) {
                  Navigator.pop(context);
                  SystemChrome.setEnabledSystemUIOverlays([]);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erreur de connexion')));
                }
              },
              child: const Text("Se connecter")),
        ),
      ],
    );
  }
}
