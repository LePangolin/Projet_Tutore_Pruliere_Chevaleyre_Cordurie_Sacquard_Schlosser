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
