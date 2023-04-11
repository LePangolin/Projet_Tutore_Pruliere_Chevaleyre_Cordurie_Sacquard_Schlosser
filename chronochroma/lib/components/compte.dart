import 'dart:convert';
import 'dart:developer';
import 'package:chronochroma/helpers/character_upgrades.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class Compte {
  static Compte? _instance;

  String? _pseudo;

  String? _avatarUrl;

  int _score = 0;

  int? _persoVieMax;

  int? _persoVitesseMax;

  int? _persoForceMax;

  int? _persoVueMax;

  String? _token;

  Compte._(
      this._pseudo,
      this._avatarUrl,
      this._score,
      this._token,
      this._persoVieMax,
      this._persoVitesseMax,
      this._persoForceMax,
      this._persoVueMax);

  static Future<Compte?> getInstance() async {
    if (_instance == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? account = prefs.getString('account');
      // account = null;
      if (account != null) {
        Map<String, dynamic> json = jsonDecode(account);
        _instance = Compte._(
            json['data']['pseudo'],
            json['data']['avatar_url'],
            json['data']['score'],
            json['data']["token"],
            json['data']["personnage"]["santeMax"],
            json['data']["personnage"]["vitesseMax"],
            json['data']["personnage"]["forceMax"],
            json['data']["personnage"]["vueMax"]);
      } else {
        _instance = null;
      }
    }
    return _instance;
  }

  static Future<bool> connexion(String pseudo, String pass) async {
    if (!await checkConnexion()) {
      return false;
    }
    var response = await http.post(
        Uri.parse("http://serverchronochroma.alwaysdata.net/user/login"),
        body: {"pseudo": pseudo, "mdp": pass});
    Map<String, dynamic> json = jsonDecode(response.body);
    if (json['data']['status'] < 200 || json['data']['status'] > 299) {
      return false;
    } else {
      _instance = Compte._(
          json['data']['pseudo'],
          json['data']['avatar_url'],
          json['data']['score'],
          json['data']["token"],
          json['data']["personnage"]["santeMax"],
          json['data']["personnage"]["vitesseMax"],
          json['data']["personnage"]["forceMax"],
          json['data']["personnage"]["vueMax"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('account', response.body);
      return true;
    }
  }

  static Future<bool> deconnexion() async {
    if (!await checkConnexion()) {
      return false;
    }
    try {
      _instance = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('account');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateAvatar(String? avatar) async {
    if (!await checkConnexion()) {
      return false;
    }
    if (avatar != null) {
      var response = await http.post(
          Uri.parse("http://serverchronochroma.alwaysdata.net/user/avatar"),
          body: {"token": _instance!._token, "avatar": avatar});
      if (response.statusCode < 200 || response.statusCode > 299) {
        return false;
      } else {
        _instance!._avatarUrl = avatar;
        Map<String, dynamic> json = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('account', _instance!.toJsonString());
        return true;
      }
    } else {
      return false;
    }
  }

  static Future<bool> upgradeCharacter(CharacterUpgrades? upgrade) async {
    if (!await checkConnexion()) {
      // print("1 pas de connexion");
      return false;
    }
    if (_instance == null) {
      // print("2 pas de compte");
      return false;
    }
    if (upgrade != null) {
      var response = await http.post(
          Uri.parse(
              "http://serverchronochroma.alwaysdata.net/user/amelioration"),
          body: {"token": _instance!._token, "amelioration": upgrade.name});
      if (response.statusCode < 200 || response.statusCode > 299) {
        // print("amelioration : ${upgrade.name}");
        // print("erreur ${response.statusCode}");
        // print(
        //     "return false dans le if (response.statusCode < 200 || response.statusCode > 299)");
        return false;
      } else {
        switch (upgrade) {
          case CharacterUpgrades.vie:
            _instance!._persoVieMax = _instance!._persoVieMax! + 1;
            break;
          case CharacterUpgrades.vitesse:
            _instance!._persoVitesseMax = _instance!._persoVitesseMax! + 1;
            break;
          case CharacterUpgrades.force:
            _instance!._persoForceMax = _instance!._persoForceMax! + 1;
            break;
          case CharacterUpgrades.vue:
            _instance!._persoVueMax = _instance!._persoVueMax! + 1;
            break;
        }
        Map<String, dynamic> json = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('account', _instance!.toJsonString());
        return true;
      }
    } else {
      // print("3 pas d'upgrade");
      return false;
    }
  }

  static Future<bool> updateScore(int incr) async {
    if (!await checkConnexion()) {
      return false;
    }
    if (_instance == null) {
      return false;
    }
    var response = await http.post(
        Uri.parse("http://serverchronochroma.alwaysdata.net/user/score"),
        body: {"token": _instance!._token, "score": (_instance!.score + incr).toString()}
    );
    if (response.statusCode < 200 || response.statusCode > 299) {
      return false;
    } else {
      _instance!._score = _instance!._score + incr;
      Map<String, dynamic> json = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('account', _instance!.toJsonString());
      return true;
    }
  }


  static Future<bool> checkConnexion() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> inscription(pseudo, pass,
      {avatar =
          "http://serverchronochroma.alwaysdata.net/img/avatar.png"}) async {
    var response = await http.post(
        Uri.parse("http://serverchronochroma.alwaysdata.net/user/register"),
        body: {"pseudo": pseudo, "mdp": pass, "avatar": avatar});
    Map<String, dynamic> json = jsonDecode(response.body);
    if (json['code'] < 200 || json['code'] > 299) {
      return false;
    } else {
      _instance = Compte._(
          json['data']['pseudo'],
          json['data']['avatar_url'],
          json['data']['score'],
          json['data']["token"],
          json['data']["personnage"]["santeMax"],
          json['data']["personnage"]["vitesseMax"],
          json['data']["personnage"]["forceMax"],
          json['data']["personnage"]["vueMax"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('account', response.body);
      return true;
    }
  }

  static Future<bool> sendPartie(String score, int seed, bool custom) async {
    if (!await checkConnexion()) {
      return false;
    }
    print(custom.toString());
    print(seed.toString());
    var response = await http.post(
        Uri.parse("http://serverchronochroma.alwaysdata.net/user/party"),
        body: {
          "token": _instance!._token,
          "score": score,
          "seed": seed.toString(),
          "custom": custom.toString()
        });
    inspect(response);
    if (response.statusCode < 200 || response.statusCode > 299) {
      return false;
    } else {
      return true;
    }
  }

  String toJsonString() {
    return '{"data":{"pseudo":"$_pseudo","avatar_url":"$_avatarUrl","score":$_score,"token":"$_token","personnage":{"santeMax":$_persoVieMax,"vitesseMax":$_persoVitesseMax,"forceMax":$_persoForceMax,"vueMax":$_persoVueMax}}}';
  }

  String? get pseudo => _pseudo;

  String? get avatarUrl => _avatarUrl;

  int get score => _score;

  String? get token => _token;

  int? get persoVieMax => _persoVieMax;

  int? get persoVitesseMax => _persoVitesseMax;

  int? get persoForceMax => _persoForceMax;

  int? get persoVueMax => _persoVueMax;
}
