import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences untuk local storage
import 'home_page.dart'; // Navigasi ke HomePage
import 'register_page.dart'; // Navigasi ke RegisterPage
import '../theme.dart'; // Pastikan tema diimport sesuai kebutuhan

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // State untuk mengontrol tampilan password
  bool _obscurePassword = true;

  // Controller untuk input field
  final TextEditingController _usernameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TapGestureRecognizer _registerTapRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _registerTapRecognizer.dispose(); // Dispose untuk menghindari kebocoran memori
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk memeriksa data login
  Future<void> _loginUser() async {
    final usernameOrEmail = _usernameOrEmailController.text.trim();
    final password = _passwordController.text;

    if (usernameOrEmail.isEmpty || password.isEmpty) {
      _showSnackbar('Semua field harus diisi');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if ((usernameOrEmail == savedUsername || usernameOrEmail == savedEmail) &&
        password == savedPassword) {
      _showSnackbar('Login berhasil!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      _showSnackbar('Username/email atau password salah');
    }
  }

  // Fungsi untuk menampilkan Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo di tengah
            Center(
              child: Container(
                width: 85,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),

            // Ilustrasi di tengah
            Center(
              child: Container(
                width: 372,
                height: 274,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/illustration_login.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),

            Text(
              'Selamat Datang Kembali!',
              style: secondaryTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),

            // Teks Sign in
            Text(
              'Sign in',
              style: primaryTextStyle.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Input Username atau Email
            TextField(
              controller: _usernameOrEmailController,
              decoration: InputDecoration(
                hintText: 'Username atau email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Input Password dengan Show/Hide Icon
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Link Daftar dan Tombol Masuk
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Teks "Belum memiliki akun?" dengan TextSpan
                RichText(
                  text: TextSpan(
                    text: 'Belum memiliki akun? ',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\nDaftar',
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: _registerTapRecognizer
                          ..onTap = () {
                            // Aksi ketika teks "Daftar" ditekan
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),

                // Tombol Masuk
                ElevatedButton(
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Masuk',
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
