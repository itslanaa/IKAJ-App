import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'bookmark_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Index untuk halaman Profile
  String _fullName = ""; // Nama lengkap pengguna
  String _email = ""; // Email pengguna
  String _username = ""; // Username pengguna

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memuat data pengguna saat halaman dimuat
  }

  // Fungsi untuk memuat data pengguna dari local storage
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('name') ?? "Nama Lengkap";
    final email = prefs.getString('email') ?? "example@email.com";
    final username = prefs.getString('username') ?? "username";

    // Pastikan data ter-update ke state
    setState(() {
      _fullName = fullName;
      _email = email;
      _username = username;
    });
  }

  // Fungsi untuk logout dengan popup konfirmasi
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Keluar'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Tidak keluar
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // Keluar
            child: Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  // Fungsi untuk menyimpan data pengguna setelah diedit
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _nameController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
    setState(() {
      _fullName = _nameController.text;
      _username = _usernameController.text;
      _email = _emailController.text;
    });
    Navigator.pop(context); // Tutup dialog
  }

  // Fungsi untuk mengganti password
  Future<void> _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final oldPassword = prefs.getString('password') ?? "";
    if (_oldPasswordController.text == oldPassword) {
      await prefs.setString('password', _newPasswordController.text);
      Navigator.pop(context); // Tutup dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password berhasil diubah!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password lama salah!')),
      );
    }
  }

  // Fungsi untuk navigasi di BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookmarkPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bagian Background Hijau dan Foto Profil
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 70),

            // Nama Pengguna
            Text(
              _fullName,
              style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              _email,
              style: secondaryTextStyle.copyWith(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 30),

            // Tombol "Informasi Saya" dan "Ubah Password"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _nameController.text = _fullName;
                      _usernameController.text = _username;
                      _emailController.text = _email;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Edit Informasi Saya'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Nama Lengkap',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: _saveUserData,
                              child: Text('Simpan'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: primaryColor),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Informasi Saya',
                          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_ios, color: primaryColor, size: 12,),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _oldPasswordController.clear();
                      _newPasswordController.clear();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Ubah Password'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _oldPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password Lama',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _newPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password Baru',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: _changePassword,
                              child: Text('Ubah'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: primaryColor),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ubah Password',
                          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_ios, color: primaryColor, size: 12,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 300),

            // Tombol Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Keluar',
                  style: whiteTextStyle.copyWith(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
