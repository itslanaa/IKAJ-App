import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ikaj_app/pages/splash_welcome.dart';
import 'package:ikaj_app/theme.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return const SplashWelcome();
      }));
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    ),
                ),
              ),
              Text(
                'Informasi Kajian',
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
        ),
      ),
    );
  }
}