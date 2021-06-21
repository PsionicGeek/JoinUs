import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:join_us/screens/homepage.dart';

import '../variables.dart';

class verify extends StatefulWidget {


  @override
  _verifyState createState() => _verifyState();
}

class _verifyState extends State<verify> {

  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  
  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      CheckEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: Stack(
          children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: GradientColors.blue)
              ),
              child: Center(
                child: Image.asset('images/logo.png', height: 100,),
              ),
            ),
            Align(alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2,
                margin: EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: const Offset(0, 3)
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 1.7,
                        child: Center(
                          child: Text('An email has been send to your email ${user
                              .email} address plz verify ',
                            style: mystyle(20, Colors.red),),
                        ),)]
                ),),
            )]
      ),
    );
  }

  Future<void> CheckEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
