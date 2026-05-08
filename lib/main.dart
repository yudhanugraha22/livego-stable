import 'package:flutter/material.dart';

void main() => runApp(const LivegoApp());

class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const MainNavigation(),
    );
  }
}

// HALAMAN NAVIGASI UTAMA (Untuk tombol bawah)
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text("Halaman Unduhan")),
    const SettingsPage(), // Sekarang tombol Akun/Settings berfungsi
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF161B22),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: "UNDUHAN"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "PENGATURAN"),
        ],
      ),
    );
  }
}

// HALAMAN BERANDA
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. DAFTAR 8 API ASLI ANDA
  final List<String> sources = [
    "Melolo", "DramaBox", "DotDrama", "Netshort", 
    "Stardusttv", "Reelife", "DramaBite", "Velolo"
  ];
  
  String selectedSource = "Melolo";
  String selectedCategory = "Populer";

  // Simulasi Kategori (Nantinya diambil dari masing-masing API)
  final List<String> categories = ["Populer", "New", "Segera Hadir", "Dubbing", "Trend"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchPage()))
          ),
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            // BANNER FEATURED
            _buildBanner(),
            const SizedBox(height: 20),
            
            // MENU 8 API DRACIN
            _buildSourceList(),
            const SizedBox(height: 10),
            
            // MENU KATEGORI (Populer, New, dll)
            _buildCategoryList(),
            
            const SizedBox(height: 15),
            // GRID KONTEN
            _buildMovieGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage("https://via.placeholder.com/600x300/1e293b/ffffff?text=Feature+Drama"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(begin: Alignment.bottomCenter, colors: [Colors.black, Colors.transparent]),
        ),
        alignment: Alignment.bottomLeft,
        child: Text("Drama Terpopuler di $selectedSource", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSourceList() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: sources.length,
        itemBuilder: (context, i) {
          bool isSel = selectedSource == sources[i];
          return GestureDetector(
            onTap: () => setState(() => selectedSource = sources[i]),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSel ? const Color(0xFF8B5CF6) : Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(sources[i], style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          bool isSel = selectedCategory == categories[i];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[i]),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isSel ? Colors.blueAccent : Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(categories[i], style: const TextStyle(fontSize: 12)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 0.6, crossAxisSpacing: 10, mainAxisSpacing: 10,
      ),
      itemCount: 9,
      itemBuilder: (context, i) => Container(
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: const Center(child: Icon(Icons.play_arrow, color: Colors.white24)),
      ),
    );
  }
}

// HALAMAN CARI (Fungsional Dasar)
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TextField(decoration: InputDecoration(hintText: "Cari Drama...", border: InputAppearance.none))),
      body: const Center(child: Text("Hasil pencarian akan muncul di sini")),
    );
  }
}

// HALAMAN PENGATURAN
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan Livego")),
      body: ListView(
        children: [
          ListTile(leading: const Icon(Icons.storage), title: const Text("Hapus Cache"), onTap: () {}),
          ListTile(leading: const Icon(Icons.info_outline), title: const Text("Versi Aplikasi"), subtitle: const Text("v1.0.0 (Livego)"), onTap: () {}),
          ListTile(leading: const Icon(Icons.language), title: const Text("Pilih Server API"), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ],
      ),
    );
  }
}
