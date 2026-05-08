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
        scaffoldBackgroundColor: const Color(0xFF090C11),
        primaryColor: Colors.blueAccent,
      ),
      home: const MainNavigation(),
    );
  }
}

// --- KOMPONEN KURSOR TV NEON ---
class TVButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  const TVButton({super.key, required this.child, required this.onTap, this.borderRadius = 12});
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
            border: Border.all(color: _isFocused ? Colors.blueAccent : Colors.transparent, width: 3.5),
            boxShadow: _isFocused ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.7), blurRadius: 15, spreadRadius: 2)] : [],
          ),
          transform: _isFocused ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // FUNGSI BERSIHKAN CACHE & KELUAR
  Future<void> _clearCacheAndExit() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
      SystemNavigator.pop(); // Keluar aplikasi
    } catch (e) {
      SystemNavigator.pop();
    }
  }

  // DIALOG KONFIRMASI KELUAR
  Future<bool> _showExitDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Keluar Aplikasi", style: TextStyle(color: Colors.blueAccent)),
        content: const Text("Apakah Anda yakin ingin keluar dan bersihkan cache?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
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
        body: IndexedStack(
          index: _currentIndex,
          children: [const HomePage(), const Center(child: Text("Halaman Unduhan")), const AccountPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: const Color(0xFF111827),
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
    // DETEKSI PERANGKAT
    double width = MediaQuery.of(context).size.width;
    bool isTV = width > 900; // Standar lebar TV landscape

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildHList(sources, selSource, (v) => setState(() => selSource = v), const Color(0xFF8B5CF6)),
            const SizedBox(height: 8),
            _buildHList(cats, selCat, (v) => setState(() => selCat = v), Colors.blueAccent),
            const SizedBox(height: 15),
            
            // GRID DINAMIS (TV 8 Kotak, HP 12 Kotak)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Tetap 4 kolom per baris sesuai request
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: isTV ? 8 : 12, // 2 baris untuk TV, 3 baris untuk HP
              itemBuilder: (c, i) => TVButton(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.white10, size: 40)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHList(List list, String sel, Function(String) onSel, Color color) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: list.length,
        itemBuilder: (c, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TVButton(
            borderRadius: 20,
            onTap: () => onSel(list[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: sel == list[i] ? color : Colors.white10, borderRadius: BorderRadius.circular(20)),
              child: Text(list[i], style: const TextStyle(fontSize: 11)),
            ),
          ),
        ),
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Akun")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TVButton(onTap: () {}, child: const ListTile(leading: Icon(Icons.history), title: Text("Riwayat"))),
          const SizedBox(height: 10),
          TVButton(onTap: () {}, child: const ListTile(leading: Icon(Icons.favorite), title: Text("Favorit"))),
          const SizedBox(height: 10),
          TVButton(onTap: () {}, child: const ListTile(leading: Icon(Icons.update), title: Text("Periksa Pembaruan"))),
        ],
      ),
    );
  }
}
