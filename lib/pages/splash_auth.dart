import 'package:flutter/material.dart';
import 'package:ikaj_app/pages/login_page.dart';
import 'package:ikaj_app/pages/register_page.dart';
import 'package:ikaj_app/theme.dart';

class SplashAuth extends StatelessWidget {
  const SplashAuth({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  ),
              ),
            ),
            SizedBox(height: 76,),
            Container(
              width: 372,
              height: 274,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/illustration_splash2.png'),
                  ),
              ),
            ),
            SizedBox(height: 35,),
            Text(
              'Sudah punya akun?',
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                fontSize: 32,
              ),
            ),
            SizedBox(height: 13,),
            Text(
              'Masuk apabila telah memiliki akun\nSilahkan mendaftar jika belum memiliki akun.',
              textAlign: TextAlign.center,
              style: secondaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 96,),
            Container(
              width: MediaQuery.of(context).size.width - (2 * defaultMargin),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // jarak antar button yh
                children: [
                  Expanded(
                    child:
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, 
                        padding: EdgeInsets.symmetric(vertical: 16), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), 
                        ),
                      ),
                      child: Text(
                        'Masuk',
                        style: whiteTextStyle.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: 
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16), 
                        side: BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), 
                        ),
                      ), 
                      child: Text(
                        'Daftar',
                        style: primaryTextStyle.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}