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
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const MainNavigation(),
    );
  }
}

// ==========================================
// KOMPONEN KURSOR TV NEON (SUPER TAJAM)
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
            border: Border.all(color: _isFocused ? Colors.blueAccent : Colors.transparent, width: 3.5),
            boxShadow: _isFocused ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.8), blurRadius: 20, spreadRadius: 3)] : [],
          ),
          transform: _isFocused ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

// ==========================================
// NAVIGASI UTAMA & FITUR KELUAR
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
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) { cacheDir.deleteSync(recursive: true); }
    SystemNavigator.pop();
  }

  Future<bool> _showExitDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Keluar Aplikasi", style: TextStyle(color: Colors.blueAccent)),
        content: const Text("Yakin ingin keluar dan bersihkan cache?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(onPressed: _clearCacheAndExit, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Keluar")),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (did, res) { if (!did) _showExitDialog(); },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
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
// HALAMAN HOME (8 API + GRID 7x2)
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
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildBanner(selSource),
            const SizedBox(height: 15),
            _buildHList(sources, selSource, (v) => setState(() => selSource = v), const Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            _buildHList(cats, selCat, (v) => setState(() => selCat = v), Colors.blueAccent),
            const SizedBox(height: 15),
            _buildGrid(isTV),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(String s) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: TVButton(onTap: (){}, child: Container(height: 180, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white10), alignment: Alignment.center, child: Text("Hot Drama on $s", style: const TextStyle(fontWeight: FontWeight.bold)))),
  );

  Widget _buildHList(List l, String s, Function(String) o, Color c) => SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: l.length, itemBuilder: (ctx, i) => Padding(padding: const EdgeInsets.only(right: 8), child: TVButton(borderRadius: 20, onTap: () => o(l[i]), child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center, decoration: BoxDecoration(color: s == l[i] ? c : Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text(l[i]))))));

  Widget _buildGrid(bool isTV) => GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(15), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isTV ? 7 : 4, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: isTV ? 14 : 12, itemBuilder: (c, i) => TVButton(onTap: (){}, child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.white10, size: 40)))));
}

// ==========================================
// HALAMAN AKUN (CINEFLOW PERMANENT)
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
            _header(),
            const SizedBox(height: 25),
            _group(context, "KOLEKSI CEPAT", [
              _item(context, Icons.history, "Riwayat", "Tontonan terakhir"),
              _item(context, Icons.favorite_border, "Favorit", "Drama favorit"),
              _item(context, Icons.settings, "Pengaturan", "Atur Player & DRM", isSet: true),
            ]),
            const SizedBox(height: 25),
            _group(context, "APLIKASI", [
              _item(context, Icons.system_update, "Pembaruan", "Versi 1.0.0"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(25)), child: Column(children: [Row(children: [const CircleAvatar(radius: 35, backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, color: Colors.white, size: 40)), const SizedBox(width: 15), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text("Akun CineFlow", style: TextStyle(color: Colors.grey))])]), const SizedBox(height: 15), Row(children: [ _btn("Telegram"), const SizedBox(width: 10), _btn("WhatsApp") ])]));
  Widget _btn(String t) => Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white10), child: Text(t, style: const TextStyle(fontSize: 12)));
  Widget _group(BuildContext ctx, String t, List<Widget> i) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))), Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: i))]);
  Widget _item(BuildContext ctx, IconData i, String t, String s, {bool isSet = false}) => TVButton(onTap: () { if(isSet) Navigator.push(ctx, MaterialPageRoute(builder: (c) => const SettingsPage())); }, child: ListTile(leading: Icon(i, color: Colors.white70), title: Text(t), subtitle: Text(s, style: const TextStyle(fontSize: 11)), trailing: const Icon(Icons.chevron_right)));
}

// ==========================================
// HALAMAN PENGATURAN (LENGKAP)
// ==========================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String drm = "AUTO";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _sect("PLAYER"),
          Container(
            decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)),
            child: Column(children: [
              TVButton(onTap: _showDRM, child: ListTile(leading: const Icon(Icons.lock), title: const Text("Widevine DRM"), subtitle: Text(drm, style: const TextStyle(color: Colors.blueAccent)), trailing: const Icon(Icons.chevron_right))),
              TVButton(onTap: (){}, child: const ListTile(leading: Icon(Icons.cached), title: Text("Gunakan Cache Playback"), trailing: Icon(Icons.toggle_on, color: Colors.blueAccent))),
            ]),
          ),
          const SizedBox(height: 20),
          _sect("SUMBER"),
          Container(
            decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)),
            child: TVButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SourceManager())), child: const ListTile(leading: Icon(Icons.layers), title: Text("Kelola Sumber Data"), subtitle: Text("8 API Aktif", style: TextStyle(fontSize: 11)), trailing: Icon(Icons.chevron_right))),
          ),
        ],
      ),
    );
  }

  void _showDRM() {
    showDialog(context: context, builder: (c) => AlertDialog(
      backgroundColor: const Color(0xFF161B22), title: const Text("Mode DRM"),
      content: Column(mainAxisSize: MainAxisSize.min, children: ["Auto", "Paksa L1", "Paksa L3"].map((v) => RadioListTile(title: Text(v), value: v, groupValue: drm, onChanged: (val) { setState(() => drm = val.toString()); Navigator.pop(context); })).toList()),
    ));
  }
  Widget _sect(String t) => Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)));
}

class SourceManager extends StatelessWidget {
  const SourceManager({super.key});
  @override
  Widget build(BuildContext context) {
    final List<String> apis = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Sumber Data"), backgroundColor: const Color(0xFF161B22)),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: apis.length,
        itemBuilder: (c, i) => Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)), child: SwitchListTile(title: Text(apis[i]), value: true, onChanged: (v){}, activeColor: Colors.blueAccent)),
      ),
    );
  }
}
