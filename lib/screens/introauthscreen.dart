import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:join_us/authentication/navigationauthscreen.dart';
import 'package:join_us/variables.dart';

class IntroAuthScreen extends StatefulWidget {
  @override
  _IntroAuthScreenState createState() => _IntroAuthScreenState();
}

class _IntroAuthScreenState extends State<IntroAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        pages: [
          PageViewModel(
              title: "Welcome",
              body: "Welcome to JoinUs",
              image: Center(
                child: Image.asset(
                  'images/welcome.png',
                  height: 175,
                ),
              ),
              decoration: PageDecoration(
                  bodyTextStyle: mystyle(20, Colors.black),
                  titleTextStyle: mystyle(20, Colors.black))),
          PageViewModel(
              title: "Join or Start Meeting",
              body: "Easy to use",
              image: Center(
                child: Image.asset(
                  'images/conference.png',
                  height: 175,
                ),
              ),
              decoration: PageDecoration(
                  bodyTextStyle: mystyle(20, Colors.black),
                  titleTextStyle: mystyle(20, Colors.black))),
          PageViewModel(
              title: "Security",
              body: "Your security is important to us. Our servers are secured",
              image: Center(
                child: Image.asset(
                  'images/secure.jpg',
                  height: 175,
                ),
              ),
              decoration: PageDecoration(
                  bodyTextStyle: mystyle(20, Colors.black),
                  titleTextStyle: mystyle(20, Colors.black)))
        ],
        onDone: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NavigateAuthScreen()));
        },
        onSkip: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NavigateAuthScreen()));
        },
        showSkipButton: true,
        skip: const Icon(Icons.skip_next, size: 40, color: Colors.blue),
        next: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.blue,
        ),
        done: Text(
          "Done",
          style: mystyle(20, Colors.blue),
        ));

  }
}
