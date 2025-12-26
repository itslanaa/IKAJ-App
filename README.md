# IKAJ App - Informasi Kajian

Aplikasi mobile Flutter untuk berbagi konten kajian Islam interaktif dengan fitur-fitur lengkap seperti video streaming, bookmark, pencarian, dan manajemen profil.

## 📋 Daftar Fitur

### 1. **Autentikasi Pengguna**
- Registrasi akun baru dengan validasi form
- Login dengan username atau email
- Sistem keamanan sederhana dengan password verification
- Penyimpanan data lokal menggunakan SharedPreferences
- Splash screen dengan flow autentikasi

### 2. **Beranda (Home Page)**
- Banner carousel otomatis dengan slide animation
- Rekomendasi video kajian berdasarkan katalog
- Grid view untuk menampilkan konten video
- Navigasi cepat ke berbagai fitur
- Bottom navigation bar untuk akses menu utama

### 3. **Video Streaming**
- Putar video kajian secara langsung
- Kontrol playback (play, pause, seek)
- Lihat deskripsi lengkap video dan nama pembicara
- Support untuk berbagai format video

### 4. **Pencarian (Search)**
- Cari konten kajian berdasarkan judul
- Filter dinamis dari katalog video
- Hasil pencarian real-time
- Akses video dari hasil pencarian

### 5. **Bookmark/Favorit**
- Simpan video favorit untuk ditonton nanti
- Kelola daftar bookmark pribadi
- Akses cepat ke konten yang disimpan
- Persistent storage dengan SharedPreferences

### 6. **Profil Pengguna (Profile)**
- Tampilkan informasi pengguna (nama, username, email)
- Edit profil pengguna
- Logout akun
- Sinkronisasi data dari local storage

### 7. **Live Kajian Widget**
- Scrape live streams dari YouTube channel menggunakan YouTube Data API v3
- Tampilkan sesi kajian live dalam list dengan thumbnail, judul, deskripsi
- Update otomatis setiap kali page dibuka
- Tap untuk langsung buka di YouTube live
- Support multiple channel YouTube
- Error handling jika API key tidak valid atau quota habis

### 8. **Splash Screens**
- Splash Logo (loading awal)
- Splash Welcome (pengenalan aplikasi)
- Splash Auth (navigasi autentikasi)

---

## 🛠️ Tech Stack

| Teknologi | Deskripsi | Versi |
|-----------|-----------|-------|
| **Flutter** | Framework UI native cross-platform | ^3.5.3 |
| **Dart** | Bahasa pemrograman | ^3.5.3 |
| **google_fonts** | Custom font Poppins dari Google Fonts | ^6.2.1 |
| **shared_preferences** | Local storage untuk data pengguna | ^2.3.4 |
| **video_player** | Video playback plugin | ^2.5.1 |
| **url_launcher** | Buka URL eksternal | ^6.1.7 |
| **http** | HTTP client untuk API calls | 1.2.2 |
| **intl** | Internationalization & localization | ^0.17.0 |
| **Material Design** | Design system Flutter | Built-in |
| **YouTube Data API v3** | Scrape live stream dari YouTube Channel | Official Google API |

---

## 🎥 Integrasi YouTube Data API v3

### Fitur Live Kajian dari YouTube
Aplikasi menggunakan **YouTube Data API v3** untuk scrape dan menampilkan live streaming kajian dari channel YouTube. 

### Cara Setup API Key

1. **Buat Google Cloud Project**
   - Buka [Google Cloud Console](https://console.cloud.google.com/)
   - Klik "Create Project"
   - Isi nama project (contoh: `IKAJ-App`)
   - Klik "Create"

2. **Enable YouTube Data API v3**
   - Di Project, pilih "APIs & Services"
   - Klik "Enable APIs and Services"
   - Cari "YouTube Data API v3"
   - Klik dan pilih "Enable"

3. **Buat API Key**
   - Di "APIs & Services", pilih "Credentials"
   - Klik "Create Credentials" → "API Key"
   - Copy API Key yang dihasilkan

4. **Update di Project**
   - Buka [lib/pages/livekajian_widget.dart](lib/pages/livekajian_widget.dart#L12)
   - Ganti `"isiapikeydisini"` dengan API Key Anda:
   ```dart
   final String apiKey = "YOUR_YOUTUBE_API_KEY_HERE";
   ```

5. **Update Channel IDs**
   - Dapatkan Channel ID dari URL YouTube channel: `youtube.com/c/CHANNEL_ID` atau `youtube.com/@CHANNEL_NAME`
   - Update `channelIds` list dengan Channel ID kajian Anda:
   ```dart
   final List<String> channelIds = [
     "UC5KW9VowHehb_jHAhDMZpEQ", // Ganti dengan Channel ID Anda
     "UClvc6c04-xEYKFFyeP3yjKA",
     // ... tambah lebih banyak sesuai kebutuhan
   ];
   ```

### Cara Kerja
- API menggunakan `search` endpoint dengan parameter:
  - `eventType=live` - mencari live streams
  - `channelId` - dari channel YouTube tertentu
  - `type=video` - filter hanya video
- Menampilkan live kajian dalam card dengan:
  - Thumbnail live stream
  - Judul kajian
  - Deskripsi
  - Nama channel
  - Link langsung ke YouTube live

### Batasan & Kuota
- **Daily Quota**: 10,000 unit per hari (default)
- **Setiap search request**: ~100 unit
- Untuk production, pertimbangkan upgrade quota di Google Cloud Console

---

## 🔐 Sistem Autentikasi

### Metode Penyimpanan Data
Aplikasi menggunakan **SharedPreferences** (local storage device) bukan database server:

```dart
// Saat registrasi - data disimpan lokal
prefs.setString('username', username);
prefs.setString('email', email);
prefs.setString('password', password);
prefs.setString('name', name);

// Saat login - data dibaca dari local storage
final savedUsername = prefs.getString('username');
final savedPassword = prefs.getString('password');
```

### Keamanan
⚠️ **Catatan Penting:**
- Password disimpan dalam **plain text** (tidak di-hash)
- Data hanya tersimpan di perangkat lokal
- Data akan **hilang jika user uninstall aplikasi**
- Cocok untuk development/prototype saja

### Rekomendasi untuk Production
Untuk aplikasi production, implementasikan:
- Backend API dengan database server (Firebase, Supabase, atau custom backend)
- Hash password menggunakan bcrypt atau algoritma standar
- Implementasi JWT token untuk session management
- Enkripsi data sensitif

---

## 📦 Instalasi & Setup

### Prerequisites
- Flutter SDK ^3.5.3
- Dart ^3.5.3
- Visual Studio Code atau Android Studio
- Device/Emulator Android atau iOS

### Langkah-langkah

1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd ikaj-app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Aplikasi**
   ```bash
   flutter run
   ```
   
   Untuk platform spesifik:
   ```bash
   flutter run -d android     # Android device/emulator
   flutter run -d ios         # iOS device
   flutter run -d chrome      # Web (experimental)
   ```

4. **Build APK/IPA**
   ```bash
   flutter build apk           # Build Android APK
   flutter build ios           # Build iOS
   ```

---

## 📁 Struktur Folder

```
ikaj-app/
├── lib/
│   ├── main.dart                    # Entry point aplikasi
│   ├── theme.dart                   # Konfigurasi tema & styling
│   └── pages/
│       ├── splash_logo.dart         # Loading screen
│       ├── splash_welcome.dart      # Welcome screen
│       ├── splash_auth.dart         # Auth navigation
│       ├── login_page.dart          # Login screen
│       ├── register_page.dart       # Register screen
│       ├── home_page.dart           # Home/beranda
│       ├── video_page.dart          # Video player
│       ├── search_page.dart         # Pencarian
│       ├── bookmark_page.dart       # Favorit/bookmark
│       ├── profile_page.dart        # Profil pengguna
│       └── livekajian_widget.dart   # Live kajian widget
├── assets/
│   ├── images/                      # Aset gambar (banner, logo, thumbnail)
│   └── videos/                      # Aset video kajian
├── pubspec.yaml                     # Package dependencies
└── README.md                        # Dokumentasi ini
```

---

## 🎨 Desain & Tema

### Palet Warna
- **Primary Color**: `#3F7396` (Biru gelap)
- **Secondary Color**: `#4F8EB5` (Biru medium)
- **Tertiary Color**: `#77BDDF` (Biru terang)
- **Quaternary Color**: `#A4E2F9` (Biru sangat terang)
- **White**: `#FFFFFF`

### Font
- **Font Family**: Poppins (dari Google Fonts)
- **Font Weight**: Regular (400) & Bold (700)

Aplikasi menggunakan `GoogleFonts.poppinsTextTheme()` untuk menerapkan Poppins secara global ke seluruh UI.

---

## 🚀 Fitur yang Akan Datang

- [ ] Sistem notifikasi push untuk live kajian baru
- [ ] Cache live stream data untuk offline viewing
- [ ] Filter & sort live kajian berdasarkan channel/waktu
- [ ] Backend API integration
- [ ] User authentication dengan Firebase
- [ ] Database cloud untuk sinkronisasi data antar device
- [ ] Comment & rating pada video
- [ ] Video download untuk offline viewing
- [ ] Social sharing fitur
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Analytics tracking untuk live kajian

---

## � Asset Video & Thumbnail

Aplikasi ini tidak menyertakan file video dan thumbnail dalam repository karena ukuran file yang besar. File-file tersebut disimpan di Google Drive untuk kemudahan distribusi.

### Download Assets

Silakan download folder asset video dan thumbnail dari link berikut:

**🔗 [Download Video & Thumbnail Assets](https://drive.google.com/file/d/1TY3LahAJr1jUAdD4Fg63BGhdggmP6wGn/view?usp=sharing)**


### Setup Assets Setelah Download

1. **Download folder dari Drive**
   - Folder harus berisi:
     ```
     assets/
     ├── videos/
     │   ├── video1.mp4
     │   ├── video2.mp4
     │   ├── video3.mp4
     │   ├── video4.mp4
     │   └── video5.mp4
     └── thumbnails/
         ├── thumbnail_video1.jpg
         ├── thumbnail_video2.jpg
         ├── thumbnail_video3.jpg
         ├── thumbnail_video4.jpg
         └── thumbnail_video5.jpg
     ```

2. **Copy ke project**
   - Extract/copy folder `assets/` ke root project directory
   - Pastikan path ada di `pubspec.yaml`:
     ```yaml
     flutter:
       uses-material-design: true
       assets:
         - assets/
     ```

3. **Rebuild aplikasi**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### File Assets yang Diperlukan

| File | Ukuran | Format |
|------|--------|--------|
| video1.mp4 | ~ | MP4 H.264 |
| video2.mp4 | ~ | MP4 H.264 |
| video3.mp4 | ~ | MP4 H.264 |
| video4.mp4 | ~ | MP4 H.264 |
| video5.mp4 | ~ | MP4 H.264 |
| thumbnail_video1.jpg | ~ | JPEG |
| thumbnail_video2.jpg | ~ | JPEG |
| thumbnail_video3.jpg | ~ | JPEG |
| thumbnail_video4.jpg | ~ | JPEG |
| thumbnail_video5.jpg | ~ | JPEG |

---

## �🐛 Troubleshooting

### Font tidak berubah ke Poppins
- Pastikan `flutter pub get` sudah dijalankan
- Clear cache: `flutter clean` kemudian `flutter pub get`
- Rebuild aplikasi: `flutter run`

### SharedPreferences data tidak tersimpan
- Pastikan plugin `shared_preferences` sudah ter-install
- Cek permission di AndroidManifest.xml (Android)
- Di iOS, cek NSUserDefaults permission di Info.plist

### Video tidak bisa diplay
- Pastikan file video sudah di-download dari Google Drive dan disimpan di folder `assets/videos/`
- Pastikan nama file sesuai: `video1.mp4`, `video2.mp4`, dst
- Verifikasi path di kode sesuai dengan file yang ada:
  ```dart
  'videoPath': 'videos/video1.mp4',
  ```
- Jalankan `flutter pub get` dan rebuild dengan `flutter run`
- Pastikan `pubspec.yaml` sudah include assets folder

### Live Kajian tidak muncul
- Pastikan API Key sudah diisi di [lib/pages/livekajian_widget.dart](lib/pages/livekajian_widget.dart#L12)
- Cek quota YouTube Data API di Google Cloud Console
- Verifikasi Channel ID sudah benar di list `channelIds`
- Pastikan ada sesi live aktif di channel YouTube yang ditambahkan

### YouTube API Error 403 (Quota Exceeded)
- Quota habis, tunggu hingga reset (24 jam)
- Atau upgrade limit di Google Cloud Console → Quotas & System Limits

### YouTube API Error 400 (Invalid Request)
- API Key tidak valid, ganti dengan key baru
- Format Channel ID salah, gunakan format dengan "UC" prefix

## 📄 Lisensi

MIT License

Copyright (c) 2025 IKAJ App Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

