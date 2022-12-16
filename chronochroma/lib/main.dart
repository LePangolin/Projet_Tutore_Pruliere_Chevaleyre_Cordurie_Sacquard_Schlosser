import './chronochroma.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'upgrade.dart';

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
          runApp(const MyApp()));
}
