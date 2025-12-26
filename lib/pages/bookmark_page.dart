import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart'; // Import primaryColor dan style
import 'video_page.dart'; // Import VideoPage untuk navigasi
import 'search_page.dart'; // Halaman Search
import 'home_page.dart'; // Halaman Dashboard
import 'profile_page.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  // Semua video yang ada
  List<Map<String, String>> _videos = [
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

  List<Map<String, String>> _bookmarkedVideos = []; // Video yang di-bookmark
  int _selectedIndex = 2; // Menandai halaman BookmarkPage di navigation bar

  @override
  void initState() {
    super.initState();
    _loadBookmarks(); // Muat bookmark dari local storage
  }

  // Fungsi untuk memuat bookmark dari local storage
  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];

    setState(() {
      // Ambil detail video berdasarkan judul yang di-bookmark
      _bookmarkedVideos = _videos
          .where((video) => bookmarkedTitles.contains(video['title']))
          .toList();
    });
  }

  // Func buat ngapus bookmark
  Future<void> _removeBookmark(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];

    if (bookmarkedTitles.contains(title)) {
      bookmarkedTitles.remove(title);
      await prefs.setStringList('bookmarks', bookmarkedTitles);
      _loadBookmarks(); // Perbarui daftar bookmark
    }
  }

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
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Bookmark Kajian',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _bookmarkedVideos.isEmpty
          ? Center(
              child: Text(
                'Belum ada video yang di-bookmark',
                style: secondaryTextStyle.copyWith(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _bookmarkedVideos.length,
              itemBuilder: (context, index) {
                final video = _bookmarkedVideos[index]; // Ambil data video yang di-bookmark
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke VideoPage
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar
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
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _removeBookmark(video['title']!);
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
