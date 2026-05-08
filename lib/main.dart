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

// HALAMAN NAVIGASI UTAMA
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
    const SettingsPage(),
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: "UNDUHAN"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN"),
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
  final List<String> sources = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];
  final List<String> categories = ["Populer", "New", "Segera Hadir", "Dubbing", "Perempuan", "Laki-Laki"];
  
  String selectedSource = "Melolo";
  String selectedCategory = "Populer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.search), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchPage()))
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildBanner(),
            const SizedBox(height: 15),
            _buildSourceList(),
            const SizedBox(height: 10),
            _buildCategoryList(),
            const SizedBox(height: 15),
            _buildMovieGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 170,
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
          gradient: const LinearGradient(begin: Alignment.bottomCenter, colors: [Colors.black87, Colors.transparent]),
        ),
        alignment: Alignment.bottomLeft,
        child: Text("Hot Drama on $selectedSource", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(sources[i]),
              selected: isSel,
              selectedColor: const Color(0xFF8B5CF6),
              onSelected: (val) => setState(() => selectedSource = sources[i]),
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
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categories[i], style: const TextStyle(fontSize: 12)),
              selected: isSel,
              selectedColor: Colors.blueAccent,
              onSelected: (val) => setState(() => selectedCategory = categories[i]),
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10,
      ),
      itemCount: 9,
      itemBuilder: (context, i) => Container(
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.white24, size: 40)),
      ),
    );
  }
}

// HALAMAN CARI (SUDAH DIPERBAIKI)
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Cari Judul Dracin...",
            border: InputBorder.none, // PERBAIKAN DI SINI
          ),
        ),
      ),
      body: const Center(child: Text("Ketik judul untuk mencari")),
    );
  }
}

// HALAMAN PENGATURAN (SUDAH DIPERBAIKI)
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan Livego")),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.transparent),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person, size: 40)),
            accountName: Text("User Livego"),
            accountEmail: Text("Gratis / VIP"),
          ),
          ListTile(leading: const Icon(Icons.history), title: const Text("Riwayat Tontonan"), onTap: () {}),
          ListTile(leading: const Icon(Icons.favorite), title: const Text("Daftar Favorit"), onTap: () {}),
          const Divider(),
          ListTile(leading: const Icon(Icons.storage), title: const Text("Bersihkan Cache"), onTap: () {}),
          ListTile(leading: const Icon(Icons.info), title: const Text("Tentang Livego"), subtitle: const Text("Versi 1.0.0"), onTap: () {}),
        ],
      ),
    );
  }
}
