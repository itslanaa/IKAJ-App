import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import untuk TapGestureRecognizer
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences untuk local storage
import 'login_page.dart';
import '../theme.dart'; // Import theme jika diperlukan

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  final TapGestureRecognizer _loginTapRecognizer = TapGestureRecognizer();

  // Controller untuk input field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginTapRecognizer.dispose(); // Dispose untuk menghindari kebocoran memori
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan data registrasi ke local storage
  Future<void> _registerUser() async {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackbar('Semua field harus diisi');
      return;
    }

    // Simpan data ke local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    _showSnackbar('Registrasi berhasil! Silakan masuk.');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
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
                width: 342,
                height: 244,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/illustration_register.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),

            // Teks Sign up
            Text(
              'Sign up',
              style: primaryTextStyle.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Input Nama Lengkap
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nama Lengkap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Input Username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Input Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
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

            // Link Masuk dan Tombol Daftar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Teks "Sudah punya akun?" dengan aksi klik pada "Masuk"
                RichText(
                  text: TextSpan(
                    text: 'Sudah punya akun? ',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '\nMasuk',
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: _loginTapRecognizer
                          ..onTap = () {
                            // Aksi ketika teks "Masuk" ditekan
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),

                // Tombol Daftar
                ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Daftar',
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
