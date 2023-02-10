import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SalonPage extends StatefulWidget {
  const SalonPage({super.key, required this.title});

  final String title;

  @override
  State<SalonPage> createState() => _SalonPageState();
}

class _SalonPageState extends State<SalonPage> {
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
        const Positioned(
            top: 20,
            left: 20,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://source.unsplash.com/50x50/?portrait',
              ),
            )),
        Container(
          child: Align(
            alignment: const Alignment(0.0, 1.8),
            child: Row(
              
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                IconButton(
                    icon: Image.asset('assets/images/button_scores.png'),
                    iconSize: MediaQuery.of(context).size.width * 0.168,
                    onPressed: () => {_launchURL()}),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.325,
                    ),
                IconButton(
                    icon: Image.asset('assets/images/button_ameliorations.png'),
                    iconSize: MediaQuery.of(context).size.width * 0.275,
                    onPressed: () =>
                        {Navigator.popAndPushNamed(context, '/upgrade')}),
                IconButton(
                    icon: Image.asset('assets/images/button_jouer.png'),
                    iconSize: MediaQuery.of(context).size.width * 0.151,
                    onPressed: () =>
                        {Navigator.popAndPushNamed(context, '/game')}),
              ],
            ),
          ),
        ),
      ]),
    ));
  }

  Future<void> _launchURL() async {
    Uri url = Uri.parse("https://chronochroma.alwaysdata.net/wordpress/");
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
