import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan bookmark
import '../theme.dart'; // Import primaryColor dan style
import 'video_page.dart'; // Import VideoPage untuk navigasi
import 'bookmark_page.dart'; // Halaman Bookmark
import 'home_page.dart'; // Halaman Dashboard
import 'profile_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Daftar video
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

  List<Map<String, String>> _filteredVideos = []; // Daftar video setelah pencarian
  List<String> _bookmarkedTitles = []; // List judul yang di-bookmark
  int _selectedIndex = 1; // Menandai halaman SearchPage di navigation bar
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredVideos = _videos; // Tampilkan semua video secara default
    _loadBookmarks(); // Muat bookmark dari local storage
  }

  // Fungsi untuk memuat bookmark dari local storage
  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];
    });
  }

  // Fungsi untuk menambah/menghapus bookmark
  Future<void> _toggleBookmark(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_bookmarkedTitles.contains(title)) {
        _bookmarkedTitles.remove(title);
      } else {
        _bookmarkedTitles.add(title);
      }
      prefs.setStringList('bookmarks', _bookmarkedTitles);
    });
  }

  // Fungsi untuk memfilter video berdasarkan pencarian
  void _filterVideos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVideos = _videos;
      } else {
        _filteredVideos = _videos.where((video) {
          final title = video['title']!.toLowerCase();
          final speaker = video['speaker']!.toLowerCase();
          final lowerCaseQuery = query.toLowerCase();

          return title.contains(lowerCaseQuery) || speaker.contains(lowerCaseQuery);
        }).toList();
      }
    });
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
        automaticallyImplyLeading: false, // disable backbutton iyh
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Cari Video Kajian',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterVideos,
                        decoration: InputDecoration(
                          hintText: 'Cari video kajian...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.filter_list, color: primaryColor),
                  ],
                ),
              ),
            ),

            // List Video
            ListView.builder(
              itemCount: _filteredVideos.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final video = _filteredVideos[index];
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke VideoPage dengan parameter
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
