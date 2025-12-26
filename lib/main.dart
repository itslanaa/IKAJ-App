import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikaj_app/pages/splash_logo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Informasi Kajian - IKAJ App',
      theme: ThemeData(
        primaryColor: Color(0xFF3F7396),
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: SplashLogo(),
      debugShowCheckedModeBanner: false,
    );
  }
}
