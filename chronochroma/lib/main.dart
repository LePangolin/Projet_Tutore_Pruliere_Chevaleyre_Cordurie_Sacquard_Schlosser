import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_page.dart';
import 'screens/home_page.dart';
import 'screens/upgrade_page.dart';
import 'screens/salon_page.dart';

void main() {
  // On s'assure que le binding est initialisé
  WidgetsFlutterBinding.ensureInitialized();
  // On désactive la rotation de l'écran
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) =>
          // On désactive la barre de statut

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []))
      .then((_) =>
          // On lance le jeu
          runApp(MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Start screen",
              initialRoute: '/',
              routes: {
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
