import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NavigationDrawer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    print("ji");
    Future.delayed(Duration(seconds: 3), () {
      // 5s over, navigate to a new page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NavigationDrawerPage()));
    });
    super.initState();
    // Timer(Duration(seconds: 3), (){   MaterialPageRoute(builder: (context) => NavigationDrawerPage());});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00a652),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .4,
            decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.white),
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage('assets/logo.jpg'))),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
