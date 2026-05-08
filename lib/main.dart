import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const LivegoApp());

class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090C11),
        primaryColor: Colors.blueAccent,
      ),
      home: const MainNavigation(),
    );
  }
}

// ==========================================
// KOMPONEN KURSOR TV (SUPER TAJAM & GLOW)
// ==========================================
class TVButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  const TVButton({super.key, required this.child, required this.onTap, this.borderRadius = 15});

  @override
  State<TVButton> createState() => _TVButtonState();
}

class _TVButtonState extends State<TVButton> {
  bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _isFocused = f),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isFocused ? Colors.blueAccent : Colors.transparent, 
              width: 3.5, // Garis lebih tebal agar tajam di TV
            ),
            boxShadow: _isFocused ? [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.8), // Efek Neon Glow
                blurRadius: 20,
                spreadRadius: 3,
              )
            ] : [],
          ),
          transform: _isFocused ? (Matrix4.identity()..scale(1.06)) : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

// ==========================================
// NAVIGASI UTAMA
// ==========================================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const HomePage(), const ContentListPage(title: "Unduhan"), const AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.download_for_offline), label: "UNDUHAN"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN"),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN BERANDA (HOME)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sources = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];
  final List<String> cats = ["Populer", "New", "Segera Hadir", "Dubbing", "Trend"];
  String selectedSource = "Melolo";
  String selectedCat = "Populer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ContentListPage(title: "Riwayat")))),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ContentListPage(title: "Favorit")))),
          IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchPage()))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildBanner(),
            const SizedBox(height: 15),
            _buildHList(sources, selectedSource, (v) => setState(() => selectedSource = v), const Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            _buildHList(cats, selectedCat, (v) => setState(() => selectedCat = v), Colors.blueAccent),
            const SizedBox(height: 15),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TVButton(
        onTap: () {},
        child: Container(
          height: 170, width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/600x300/1e293b/ffffff?text=Feature+Drama"), fit: BoxFit.cover)),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(15),
          child: Text("Hot Drama on $selectedSource", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildHList(List list, String sel, Function(String) onSel, Color color) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: list.length,
        itemBuilder: (c, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TVButton(
            borderRadius: 20,
            onTap: () => onSel(list[i]),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center, decoration: BoxDecoration(color: sel == list[i] ? color : Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text(list[i], style: const TextStyle(fontSize: 12))),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: 6,
      itemBuilder: (c, i) => TVButton(onTap: () {}, child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white10))),
    );
  }
}

// ==========================================
// HALAMAN AKUN
// ==========================================
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildProfileCard(),
            const SizedBox(height: 25),
            _buildMenuSection(context, "KOLEKSI CEPAT", [
              _menuItem(context, Icons.history, "Riwayat", "Lanjutkan tontonan terakhir"),
              _menuItem(context, Icons.favorite_border, "Favorit", "Daftar drama yang disimpan"),
              _menuItem(context, Icons.settings, "Pengaturan", "Atur Player, DRM, & Tampilan", isSettings: true),
            ]),
            const SizedBox(height: 25),
            _buildMenuSection(context, "DUKUNGAN", [
              _menuItem(context, Icons.system_update, "Pembaruan", "Versi 1.0.0"),
              _menuItem(context, Icons.help_outline, "Bantuan", "Panduan fitur utama"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)),
      child: const Row(children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.blueAccent, child: Icon(Icons.person, size: 35)),
        SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Akun Gratis / VIP", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      ]),
    );
  }

  Widget _buildMenuSection(BuildContext context, String title, List<Widget> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
      Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: items)),
    ]);
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String sub, {bool isSettings = false}) {
    return TVButton(
      onTap: () {
        if (isSettings) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsPage()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (c) => ContentListPage(title: title)));
        }
      },
      child: ListTile(leading: Icon(icon, color: Colors.white70), title: Text(title), subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)), trailing: const Icon(Icons.chevron_right, size: 18)),
    );
  }
}

// ==========================================
// HALAMAN PENGATURAN (DRM L1, L2, L3)
// ==========================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String widevine = "Auto";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan Livego")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Container(
            decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)),
            child: Column(children: [
              TVButton(
                onTap: () => _showDRMDialog(),
                child: ListTile(
                  leading: const Icon(Icons.lock_person_outlined),
                  title: const Text("Widevine DRM (L1, L2, L3)"),
                  subtitle: Text(widevine, style: const TextStyle(color: Colors.blueAccent)),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              TVButton(onTap: () {}, child: const ListTile(leading: Icon(Icons.cached), title: Text("Hapus Cache Streaming"))),
            ]),
          ),
        ],
      ),
    );
  }

  void _showDRMDialog() {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: const Text("Mode Widevine DRM"),
      backgroundColor: const Color(0xFF161B22),
      content: Column(mainAxisSize: MainAxisSize.min, children: ["Auto", "Paksa L1", "Paksa L3"].map((v) => RadioListTile(
        title: Text(v), value: v, groupValue: widevine, 
        onChanged: (val) { setState(() => widevine = val.toString()); Navigator.pop(context); }
      )).toList()),
    ));
  }
}

// HALAMAN DAFTAR (RIWAYAT, FAVORIT, DLL)
class ContentListPage extends StatelessWidget {
  final String title;
  const ContentListPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Daftar $title akan muncul di sini")),
    );
  }
}

// HALAMAN CARI
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TextField(autofocus: true, decoration: InputDecoration(hintText: "Cari Dracin...", border: InputBorder.none))),
      body: const Center(child: Text("Hasil pencarian")),
    );
  }
}
