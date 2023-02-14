import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Compte {
  static Compte? _instance;

  String? _pseudo;

  String? _avatarUrl;

  int? _score;

  int? _persoVieMax;

  int? _persoVitesseMax;

  int? _persoForceMax;

  int? _persoVueMax;

  Compte._(this._pseudo, this._avatarUrl, this._score, this._persoVieMax,
      this._persoVitesseMax, this._persoForceMax, this._persoVueMax);

  static Future<Compte?> getInstance() async {
    if (_instance == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? account = prefs.getString('account');
      if (account != null) {
        Map<String, dynamic> json = jsonDecode(account);
        _instance = Compte._(
            json['pseudo'],
            json['avatar_url'],
            json['score'],
            json["personnage"]["santeMax"],
            json["personnage"]["vitesseMax"],
            json["personnage"]["forceMax"],
            json["personnage"]["vueMax"]);
      } else {
        _instance = null;
      }
    }
    return _instance;
  }
}
