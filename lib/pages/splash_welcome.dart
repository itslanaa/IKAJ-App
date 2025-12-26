import 'package:flutter/material.dart';
import 'package:ikaj_app/pages/splash_auth.dart';
import 'package:ikaj_app/theme.dart';

class SplashWelcome extends StatelessWidget {
  const SplashWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Container(
                  width: 85,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                    ),
                  ),
                ),
                SizedBox(height: 76),
                Container(
                  width: 372,
                  height: 274,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/illustration_splash1.png'),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Kajianmu, di Genggamanmu!',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle.copyWith(
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  'Temukan cahaya ilmu, perkaya iman\ndengan informasi kajian terlengkap di IKAJ.',
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 96),
                Container(
                  width: MediaQuery.of(context).size.width - (2 * defaultMargin),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return const SplashAuth();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Mengatur warna tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Opsional: Membuat sudut tombol melengkung
                      ),
                    ),
                    child: Text(
                      'Mulai',
                      style: whiteTextStyle.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
