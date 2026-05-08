import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const LivegoApp());

class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117), // Warna Hitam CineFlow
        primaryColor: const Color(0xFF8B5CF6), // Ungu CineFlow
      ),
      home: const MainNavigation(),
    );
  }
}

// ==========================================
// KOMPONEN KURSOR TV NEON (SANGAT TAJAM)
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isFocused ? Colors.blueAccent : Colors.transparent, 
              width: 3.5,
            ),
            boxShadow: _isFocused ? [
              BoxShadow(color: Colors.blueAccent.withOpacity(0.8), blurRadius: 20, spreadRadius: 3)
            ] : [],
          ),
          transform: _isFocused ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

// ==========================================
// NAVIGASI UTAMA & FITUR EXIT (HAPUS CACHE)
// ==========================================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const HomePage(), const Center(child: Text("Halaman Unduhan")), const AccountPage()];

  Future<void> _clearCacheAndExit() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) { cacheDir.deleteSync(recursive: true); }
      SystemNavigator.pop();
    } catch (e) { SystemNavigator.pop(); }
  }

  Future<bool> _showExitDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Keluar Aplikasi", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        content: const Text("Yakin ingin keluar dan bersihkan cache?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => _clearCacheAndExit(), 
            child: const Text("Ya, Keluar")
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) { if (!didPop) _showExitDialog(); },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: const Color(0xFF161B22),
          selectedItemColor: Colors.blueAccent,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
            BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: "UNDUHAN"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN"),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN HOME (CINEFLOW TV STYLE)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sources = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];
  final List<String> cats = ["Populer", "New", "Segera Hadir", "Dubbing", "Trend"];
  String selSource = "Melolo";
  String selCat = "Populer";

  @override
  Widget build(BuildContext context) {
    bool isTV = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildBanner(),
            const SizedBox(height: 15),
            _buildHList(sources, selSource, (v) => setState(() => selSource = v), const Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            _buildHList(cats, selCat, (v) => setState(() => selCat = v), Colors.blueAccent),
            const SizedBox(height: 15),
            _buildMovieGrid(isTV),
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/600x300/1e293b/ffffff"), fit: BoxFit.cover),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(begin: Alignment.bottomCenter, colors: [Colors.black, Colors.transparent])),
            alignment: Alignment.bottomLeft,
            child: Text("Drama Terpopuler di $selSource", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center,
              decoration: BoxDecoration(color: sel == list[i] ? color : Colors.white10, borderRadius: BorderRadius.circular(20)),
              child: Text(list[i], style: const TextStyle(fontSize: 12)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieGrid(bool isTV) {
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: isTV ? 8 : 12, // TV 8 kotak, HP 12 kotak
      itemBuilder: (c, i) => Column(
        children: [
          Expanded(
            child: TVButton(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white10, borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/200x300"), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text("Judul Film...", style: TextStyle(fontSize: 10), maxLines: 1),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN AKUN (MEWAH CINEFLOW STYLE)
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
              _menuItem(context, Icons.settings, "Pengaturan", "Atur Player, DRM, & Tampilan"),
            ]),
            const SizedBox(height: 25),
            _buildMenuSection(context, "DUKUNGAN", [
              _menuItem(context, Icons.system_update, "Pembaruan", "Cek versi terbaru"),
              _menuItem(context, Icons.feedback, "Feedback", "Laporkan masalah aplikasi"),
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

  Widget _menuItem(BuildContext context, IconData icon, String title, String sub) {
    return TVButton(
      onTap: () {
        if (title == "Pengaturan") Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsPage()));
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
      appBar: AppBar(title: const Text("Pengaturan Livego"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildSect("PLAYER"),
          Container(
            decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)),
            child: Column(children: [
              TVButton(
                onTap: () => _showDRMDialog(),
                child: ListTile(
                  leading: const Icon(Icons.lock_person),
                  title: const Text("Kompatibilitas Widevine DRM"),
                  subtitle: Text(widevine, style: const TextStyle(color: Colors.blueAccent)),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              TVButton(onTap: () {}, child: const ListTile(leading: Icon(Icons.cached), title: Text("Gunakan Cache Playback"), trailing: Icon(Icons.toggle_on, color: Colors.blueAccent))),
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
  Widget _buildSect(String t) => Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)));
}
