import 'package:flutter/material.dart';
import 'package:ikaj_app/pages/livekajian_widget.dart';
import 'package:ikaj_app/pages/profile_page.dart';
import 'dart:async'; // Untuk timer auto-slide
import 'dart:math'; // Untuk randomisasi video
import 'package:shared_preferences/shared_preferences.dart'; // Untuk local storage
import '../theme.dart'; // Import primaryColor dari theme.dart
import 'search_page.dart';
import 'bookmark_page.dart';
import 'video_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<String> _bannerImages = [
    'banner1.png',
    'banner2.png',
    'banner3.png',
  ];
  int _selectedIndex = 0; // Untuk melacak index BottomNavigationBar

  // Daftar video untuk rekomendasi
  final List<Map<String, String>> _allVideos = [
    {
      'title': 'Perbaiki shalatmu maka Allah akan permudah urusanmu',
      'description': 'Shalat yang benar adalah solusi terbaik untuk setiap masalah...',
      'speaker': 'Ust. Adi Hidayat',
      'image': 'videos/thumbnail_video1.jpg',
      'videoPath': 'videos/video1.mp4',
    },
    {
      'title': 'Cara menghilangkan gundah & gelisah',
      'description': 'Kajian penting untuk menghilangkan kegelisahan di hati...',
      'speaker': 'Ust. Adi Hidayat',
      'image': 'videos/thumbnail_video2.jpg',
      'videoPath': 'videos/video2.mp4',
    },
    {
      'title': 'Al-Qur\'an merubah pribadi kita menjadi istimewa',
      'description': 'Memahami Al-Qur\'an membuat hidup lebih berkah...',
      'speaker': 'Ust. Adi Hidayat',
      'image': 'videos/thumbnail_video3.jpg',
      'videoPath': 'videos/video3.mp4',
    },
    {
      'title': 'Mengejar akhirat dunia pun didapat',
      'description': 'Dengan mengejar akhirat, dunia akan mengikuti...',
      'speaker': 'Ust. Adi Hidayat',
      'image': 'videos/thumbnail_video4.jpg',
      'videoPath': 'videos/video4.mp4',
    },
    {
      'title': 'Kalau kamu gak mau capek serahkan ke Allah',
      'description': 'Menyerahkan segalanya kepada Allah adalah kunci ketenangan...',
      'speaker': 'Ust. Adi Hidayat',
      'image': 'videos/thumbnail_video5.jpg',
      'videoPath': 'videos/video5.mp4',
    },
  ];

  late List<Map<String, String>> _recommendedVideos;
  String _username = ''; // Nama default sebelum data user didapatkan
  List<String> _bookmarkedTitles = []; // List judul video yang di-bookmark

  @override
  void initState() {
    super.initState();

    // Randomize 3 videos from the full list
    _recommendedVideos = List<Map<String, String>>.from(_allVideos);
    _recommendedVideos.shuffle(Random());
    _recommendedVideos = _recommendedVideos.take(3).toList();

    // Timer untuk auto-slide setiap 3 detik
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    // Muat nama pengguna dan bookmark
    _loadUserData();
    _loadBookmarks();
  }

  // Fungsi untuk memuat nama pengguna dari local storage
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    setState(() {
      _username = username;
    });
  }

  // Fungsi untuk memuat bookmark dari local storage
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];
    });
  }

  // Fungsi untuk menambah/menghapus bookmark
  Future<void> _toggleBookmark(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_bookmarkedTitles.contains(title)) {
        _bookmarkedTitles.remove(title);
      } else {
        _bookmarkedTitles.add(title);
      }
      prefs.setStringList('bookmarks', _bookmarkedTitles);
    });
  }

  // Fungsi untuk navigasi di BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Jika sudah di halaman yang sama, tidak perlu navigasi ulang
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi berdasarkan index tombol yang diklik
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Navigasi ke DashboardPage
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()), // Navigasi ke SearchPage
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookmarkPage()), // Navigasi ke BookmarkPage
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()), // Navigasi ke ProfilePage
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leadingWidth: 60, // Memperluas area leading agar cukup untuk logo besar
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Jarak dari tepi kiri
          child: SizedBox(
            width: 40, // Atur ukuran area logo
            height: 40,
            child: Image.asset(
              'logo-white.png', // Path logo Anda
              fit: BoxFit.contain, // Pastikan logo dipertahankan proporsinya
            ),
          ),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Geser ikon notifikasi ke kiri
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Aksi untuk notifikasi
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Background Hijau dan Teks "Assalamualaikum [Username]"
            Container(
              height: 80, // Tinggi disamakan dengan Container background hijau
              width: double.infinity, // Lebar penuh
              color: primaryColor, // Warna latar belakang hijau
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding untuk teks
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Teks berada di tengah secara vertikal
                children: [
                  Text(
                    'Assalamualaikum',
                    style: whiteRegularTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _username, // Tampilkan nama pengguna
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Section Background Hijau dengan Slider Banner
            Stack(
              clipBehavior: Clip.none, // Agar elemen di luar Stack tidak terpotong
              children: [
                // Background Hijau
                Container(
                  height: 80, // Tinggi Container
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                // Banner Slider
                Positioned(
                  bottom: -50, // Banner mengambang di atas garis putih
                  left: 17,
                  right: 17,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 110, // Tinggi slider banner
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemCount: _bannerImages.length,
                            itemBuilder: (context, index) {
                              return Image.asset(
                                _bannerImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Indikator Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _bannerImages.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? primaryColor : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 80), // Jarak antara banner dan elemen berikutnya

            // Rekomendasi Kajian Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Rekomendasi ',
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'kajian',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Daftar Rekomendasi
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _recommendedVideos.length,
              itemBuilder: (context, index) {
                final video = _recommendedVideos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPage(
                          videoPath: video['videoPath']!,
                          title: video['title']!,
                          speaker: video['speaker']!,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              video['image']!,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tema',
                                  style: secondaryTextStyle.copyWith(fontSize: 14),
                                ),
                                Text(
                                  video['title']!,
                                  style: primaryTextStyle.copyWith(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  video['description']!,
                                  style: secondaryTextStyle.copyWith(fontSize: 12, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      video['speaker']!,
                                      style: secondaryTextStyle.copyWith(fontSize: 12, color: Colors.grey),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _bookmarkedTitles.contains(video['title']!)
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        _toggleBookmark(video['title']!);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20), // Jarak tambahan

            // Live Kajian Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Live ',
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'kajian',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            LiveKajianWidget(),
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
