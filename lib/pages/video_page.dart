import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme.dart'; // Import untuk warna dan style
import 'home_page.dart';
import 'search_page.dart';
import 'bookmark_page.dart';
import 'dart:math'; // Untuk randomisasi
import 'package:shared_preferences/shared_preferences.dart'; // Untuk local storage

class VideoPage extends StatefulWidget {
  final String videoPath; // Path video
  final String title; // Judul video
  final String speaker; // Nama ustadz

  VideoPage({
    required this.videoPath,
    required this.title,
    required this.speaker,
  });

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller; // Controller untuk video player
  int _selectedIndex = 1; // Set nilai awal ke SearchPage (index 1)
  List<String> _bookmarkedTitles = []; // List judul video yang di-bookmark

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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {}); // Update UI setelah video diinisialisasi
        _controller.play();
      });

    // Filter video selain yang sedang diputar
    final List<Map<String, String>> otherVideos =
        _allVideos.where((video) => video['title'] != widget.title).toList();

    // Randomize rekomendasi video
    otherVideos.shuffle(Random());
    _recommendedVideos = otherVideos.take(2).toList();

    // Muat bookmark
    _loadBookmarks();
  }

  @override
  void dispose() {
    _controller.dispose(); // Membersihkan controller saat halaman ditutup
    super.dispose();
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
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    // Navigasi berdasarkan index tombol yang diklik
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
        backgroundColor: primaryColor,
        elevation: 0,
        leadingWidth: 40, 
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Memberikan padding agar ukuran lebih kecil
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14, // Ukuran lingkaran tombol diperkecil
              child: Icon(Icons.arrow_back, color: primaryColor, size: 18), // Ukuran ikon diperkecil
            ),
          ),
        ),
        title: Text(
          'Video Kajian',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Background Hijau dan Video Player
            Container(
              height: 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150, // Background hijau di bagian atas
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
                    bottom: -50,
                    left: 16,
                    right: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 200,
                        color: Colors.black,
                        child: _controller.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              )
                            : Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70), // Jarak antara video player dan konten di bawahnya

            // Informasi Video
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.speaker,
                              style: secondaryTextStyle.copyWith(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _bookmarkedTitles.contains(widget.title)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          _toggleBookmark(widget.title);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
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
                ],
              ),
            ),

            // Rekomendasi Video
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _recommendedVideos.length,
              itemBuilder: (context, index) {
                final video = _recommendedVideos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
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
                                  video['title']!,
                                  style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  video['description']!,
                                  style: secondaryTextStyle.copyWith(fontSize: 12, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
            label: 'Search',
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
