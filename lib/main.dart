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
// KURSOR TV NEON (FONDASI ABADI)
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
              width: 3.0,
            ),
            boxShadow: _isFocused ? [
              BoxShadow(color: Colors.blueAccent.withOpacity(0.7), blurRadius: 15, spreadRadius: 2)
            ] : [],
          ),
          transform: _isFocused ? (Matrix4.identity()..scale(1.04)) : Matrix4.identity(),
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
        title: const Text("Keluar", style: TextStyle(color: Colors.blueAccent)),
        content: const Text("Keluar dan bersihkan cache?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: _clearCacheAndExit, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Keluar")),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (did) { if(!did) _showExitDialog(); },
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
            BottomNavigationBarItem(icon: Icon(Icons.download), label: "UNDUHAN"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN"),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN BERANDA (GRID 7x2 TV)
// ==========================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    bool isTV = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF161B22), title: const Text("Livego")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildBanner(),
            const SizedBox(height: 15),
            _buildGrid(isTV),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() => Container(
    height: 180, margin: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white10),
    alignment: Alignment.center, child: const Text("BANNER CINEFLOW STYLE"),
  );

  Widget _buildGrid(bool isTV) => GridView.builder(
    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(15),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isTV ? 7 : 4, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10
    ),
    itemCount: isTV ? 14 : 12,
    itemBuilder: (c, i) => TVButton(onTap: (){}, child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)))),
  );
}

// ==========================================
// HALAMAN AKUN (IDENTIK CINEFLOW)
// ==========================================
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            _buildCineFlowHeader(),
            const SizedBox(height: 25),
            _buildSectionLabel("KOLEKSI CEPAT"),
            _buildCineCard([
              _cineItem(context, Icons.history, "Riwayat", "Lanjutkan dari tontonan terakhir", () {}),
              _cineItem(context, Icons.favorite_border, "Favorit", "Buka daftar judul favorit Anda", () {}),
              _cineItem(context, Icons.settings_outlined, "Pengaturan", "Atur tampilan, player, dan source", () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsPage()));
              }),
            ]),
            const SizedBox(height: 25),
            _buildSectionLabel("APLIKASI & DUKUNGAN"),
            _buildCineCard([
              _cineItem(context, Icons.system_update_alt, "Periksa Pembaruan", "Cek versi terbaru Livego", () {}),
              _cineItem(context, Icons.share, "Dukung Livego", "Bantu maintenance lewat donasi", () {}),
              _cineItem(context, Icons.feedback_outlined, "Kirim Feedback", "Laporkan bug atau masalah", () {}),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildCineFlowHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: const Color(0xFF161B22)),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 35, backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, size: 40, color: Colors.white)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("User Penggemar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Akun CineFlow", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _socialBtn("Telegram", Colors.blue),
              const SizedBox(width: 10),
              _socialBtn("WhatsApp", Colors.green),
            ],
          )
        ],
      ),
    );
  }

  Widget _socialBtn(String t, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white10),
    child: Text(t, style: const TextStyle(fontSize: 12)),
  );

  Widget _buildSectionLabel(String t) => Padding(padding: const EdgeInsets.only(left: 10, bottom: 10), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)));

  Widget _buildCineCard(List<Widget> items) => Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: items));

  Widget _cineItem(BuildContext ctx, IconData i, String t, String s, VoidCallback click) => TVButton(
    onTap: click,
    child: ListTile(
      leading: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle), child: Icon(i, size: 20)),
      title: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(s, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, size: 18),
    ),
  );
}

// ==========================================
// HALAMAN PENGATURAN (DETAIIL CINEFLOW)
// ==========================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool bgPoster = false;
  bool cachePlay = true;
  bool rotasi = true;
  String drm = "AUTO";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text("Pengaturan Livego")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _group("TAMPILAN & NAVIGASI", [
            _tile(Icons.settings_suggest, "Otomatis (Ikuti Hardware)", trailing: const Icon(Icons.radio_button_checked, color: Colors.blueAccent)),
          ]),
          const SizedBox(height: 20),
          _group("PLAYER", [
            _switch(Icons.image_outlined, "Tampilkan Background Poster", bgPoster, (v)=>setState(()=>bgPoster=v)),
            _switch(Icons.cached, "Gunakan Cache Playback", cachePlay, (v)=>setState(()=>cachePlay=v)),
            _switch(Icons.screen_rotation, "Tampilkan Tombol Rotasi", rotasi, (v)=>setState(()=>rotasi=v)),
            _tile(Icons.lock_outline, "Kompatibilitas Widevine DRM", sub: drm),
          ]),
          const SizedBox(height: 20),
          _group("SUMBER & IZIN", [
            _tile(Icons.layers_outlined, "Kelola Sumber Data", sub: "Aktifkan hanya source yang ingin muncul", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const SourceManagerPage()));
            }),
          ]),
          const SizedBox(height: 20),
          _group("PERAWATAN", [
            _tile(Icons.delete_sweep_outlined, "Hapus Semua Cache", color: Colors.redAccent),
          ]),
        ],
      ),
    );
  }

  Widget _group(String t, List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(left: 10, bottom: 10), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
    Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)), child: Column(children: c)),
  ]);

  Widget _tile(IconData i, String t, {String? sub, Widget? trailing, VoidCallback? onTap, Color? color}) => TVButton(
    onTap: onTap ?? (){},
    child: ListTile(
      leading: Icon(i, color: color ?? Colors.white70),
      title: Text(t, style: TextStyle(fontSize: 14, color: color)),
      subtitle: sub != null ? Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 18),
    ),
  );

  Widget _switch(IconData i, String t, bool v, Function(bool) c) => SwitchListTile(
    secondary: Icon(i, color: Colors.white70), title: Text(t, style: const TextStyle(fontSize: 14)),
    value: v, onChanged: c, activeColor: Colors.blueAccent,
  );
}

// ==========================================
// KELOLA SUMBER DATA (8 API ASLI)
// ==========================================
class SourceManagerPage extends StatelessWidget {
  const SourceManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> apis = [
      {"n": "Melolo", "d": "Nonton koleksi drama pendek Melolo terbaik."},
      {"n": "DramaBox", "d": "Tempat nonton film dan serial TV favorit."},
      {"n": "DotDrama", "d": "Update harian drama china populer."},
      {"n": "Netshort", "d": "Video pendek dan drama vertikal."},
      {"n": "Stardusttv", "d": "Konten premium dari platform Stardust."},
      {"n": "Reelife", "d": "Drama pendek dengan kualitas HD."},
      {"n": "DramaBite", "d": "Koleksi drama singkat paling viral."},
      {"n": "Velolo", "d": "Sumber data alternatif untuk drama asia."},
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF161B22), title: const Text("Kelola Sumber Data")),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: apis.length,
        itemBuilder: (c, i) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)),
          child: SwitchListTile(
            title: Text(apis[i]['n']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(apis[i]['d']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            value: true,
            onChanged: (v) {},
            activeColor: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
