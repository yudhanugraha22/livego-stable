import 'package:flutter/material.dart';

void main() => runApp(const LivegoApp());

class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090C11),
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const MainNavigation(),
    );
  }
}

// 1. NAVIGASI UTAMA (BOTTOM NAV)
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
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF111827),
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

// 2. HALAMAN HOME (8 API DRACIN)
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sources = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];
  final List<String> categories = ["Populer", "New", "Segera Hadir", "Dubbing", "Trend"];
  String selectedSource = "Melolo";
  String selectedCat = "Populer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
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
            _buildHorizontalList(sources, selectedSource, (val) => setState(() => selectedSource = val), const Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            _buildHorizontalList(categories, selectedCat, (val) => setState(() => selectedCat = val), Colors.blueAccent),
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
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/600x300/1e293b/ffffff"), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(begin: Alignment.bottomCenter, colors: [Colors.black, Colors.transparent])),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomLeft,
        child: Text("Hot Drama on $selectedSource", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHorizontalList(List<String> list, String selected, Function(String) onSel, Color color) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: list.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(label: Text(list[i]), selected: selected == list[i], selectedColor: color, onSelected: (v) => onSel(list[i])),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: 9,
      itemBuilder: (context, i) => Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.play_arrow, color: Colors.white10, size: 40)),
    );
  }
}

// 3. HALAMAN AKUN (TAMPILAN MEWAH)
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildProfileHeader(),
            const SizedBox(height: 25),
            _buildSectionTitle("KOLEKSI CEPAT"),
            _buildCard([
              _menuItem(Icons.history, "Riwayat", "Tontonan terakhir Anda"),
              _menuItem(Icons.favorite_border, "Favorit", "Daftar favorit Anda"),
              _menuItem(Icons.settings, "Pengaturan", "Atur tampilan, player, dan DRM", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsPage()));
              }),
            ]),
            const SizedBox(height: 25),
            _buildSectionTitle("DUKUNGAN"),
            _buildCard([
              _menuItem(Icons.system_update, "Periksa Pembaruan", "Versi 1.0.0"),
              _menuItem(Icons.feedback, "Kirim Feedback", "Laporkan masalah"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xFF161B22)),
      child: Row(
        children: [
          const CircleAvatar(radius: 30, backgroundColor: Colors.blue, child: Icon(Icons.person, size: 35)),
          const SizedBox(width: 15),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Akun Gratis", style: TextStyle(color: Colors.grey)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Align(alignment: Alignment.centerLeft, child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey))));

  Widget _buildCard(List<Widget> children) => Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: children));

  Widget _menuItem(IconData icon, String title, String sub, {VoidCallback? onTap}) => ListTile(
    leading: Icon(icon, color: Colors.white70),
    title: Text(title, style: const TextStyle(fontSize: 14)),
    subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    trailing: const Icon(Icons.chevron_right, size: 18),
    onTap: onTap,
  );
}

// 4. HALAMAN PENGATURAN (DETAIIL CINEFLOW STYLE)
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String widevine = "Auto";
  bool cachePlayback = true;
  bool rotasiManual = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF090C11), title: const Text("Pengaturan Livego")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildSectionTitle("TAMPILAN & NAVIGASI"),
          _buildCard([
             _settingTile(Icons.app_settings_alt, "Otomatis (Ikuti Hardware)", trailing: const Icon(Icons.radio_button_checked, color: Colors.blue)),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle("PLAYER"),
          _buildCard([
            _switchTile(Icons.cached, "Gunakan Cache Playback", cachePlayback, (v) => setState(() => cachePlayback = v)),
            _switchTile(Icons.screen_rotation, "Tampilkan Tombol Rotasi", rotasiManual, (v) => setState(() => rotasiManual = v)),
            _settingTile(Icons.lock_outline, "Kompatibilitas Widevine DRM", 
              sub: widevine, 
              onTap: () => _showDRMDialog()),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle("PERAWATAN"),
          _buildCard([
            _settingTile(Icons.delete_sweep, "Hapus Semua Cache", sub: "Bersihkan ruang penyimpanan", color: Colors.redAccent),
          ]),
        ],
      ),
    );
  }

  void _showDRMDialog() {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: const Text("Mode Widevine DRM"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _radioDRM("Auto"), _radioDRM("Paksa L3"), _radioDRM("Nonaktifkan Paksa L3"),
      ]),
    ));
  }

  Widget _radioDRM(String val) => RadioListTile(title: Text(val), value: val, groupValue: widevine, onChanged: (v) {
    setState(() => widevine = v.toString()); Navigator.pop(context);
  });

  Widget _buildSectionTitle(String t) => Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)));

  Widget _buildCard(List<Widget> c) => Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)), child: Column(children: c));

  Widget _settingTile(IconData i, String t, {String? sub, Widget? trailing, VoidCallback? onTap, Color? color}) => ListTile(
    leading: Icon(i, color: color ?? Colors.white70),
    title: Text(t, style: TextStyle(fontSize: 14, color: color)),
    subtitle: sub != null ? Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
    trailing: trailing ?? const Icon(Icons.chevron_right, size: 18),
    onTap: onTap,
  );

  Widget _switchTile(IconData i, String t, bool val, Function(bool) onChanged) => SwitchListTile(
    secondary: Icon(i, color: Colors.white70),
    title: Text(t, style: const TextStyle(fontSize: 14)),
    value: val, onChanged: onChanged,
  );
}
