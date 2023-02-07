import './chronochroma.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gamePage.dart';
import 'homepage.dart';
import 'upgrade.dart';
import 'salonPage.dart';

void main() {
  // On s'assure que le binding est initialisé
  WidgetsFlutterBinding.ensureInitialized();
  // On désactive la rotation de l'écran
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) =>
          // On désactive la barre de statut
          SystemChrome.setEnabledSystemUIOverlays([]))
      .then((_) =>
          // On lance le jeu
          runApp(MaterialApp(title: "Start screen", initialRoute: '/', routes: {
            '/': (context) => const MyHomePage(
                  title: 'homePage',
                ),
            '/upgrade': (context) => const UpgradePage(
                  title: 'upgradePage',
                ),
            '/game': (context) => GamePage(),
            '/salon': (context) => const SalonPage(
                  title: 'salonPage',
                ),
          })));
}
