import 'dart:async';
import 'package:pressfame_new/constant/Constant.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
   
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(APP_SCREEN);
  }


  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 4));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();

    // new Timer(new Duration(milliseconds: 3000), () {
    //   checkFirstSeen();
    // });
  }

  @override
void dispose() {
  animationController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: Container(
                height: SizeConfig.safeBlockVertical * 20,
                width: SizeConfig.screenWidth,
                // height: 130,
                // width: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: 100,
          //     width: 100,
          //     child: Image.asset(
          //       'assets/images/Layer2.png',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

