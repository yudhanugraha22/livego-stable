import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 40),
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Color(0xFF8B5CF6)),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Akun CineFlow", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // KOLEKSI
          const Text("KOLEKSI", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _menuCard(Icons.history, "Riwayat", "Lanjutkan dari tontonan terakhir", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const HistoryPage()));
          }),
          _menuCard(Icons.favorite, "Favorit", "Drama yang Anda simpan", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const FavoritePage()));
          }),
          
          const SizedBox(height: 20),
          
          // PENGATURAN
          const Text("PENGATURAN", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _menuCard(Icons.settings, "Pengaturan", "Atur tampilan & player", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsPage()));
          }),
          _menuCard(Icons.source, "Kelola Sumber Data", "Aktifkan platform yang muncul", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const SourceManager()));
          }),
          
          const SizedBox(height: 20),
          
          // DUKUNGAN
          const Text("DUKUNGAN", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _menuCard(Icons.update, "Periksa Pembaruan", "Cek versi terbaru", () {}),
          _menuCard(Icons.feedback, "Kirim Feedback", "Laporkan bug atau saran", () {}),
          _menuCard(Icons.help, "Bantuan", "Panduan penggunaan", () {}),
        ],
      ),
    );
  }
  
  Widget _menuCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8B5CF6)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

// Halaman Riwayat dengan fitur hapus
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
  
  Future<void> _loadHistory() async {
    final p = await SharedPreferences.getInstance();
    List<String>? saved = p.getStringList('history');
    if (saved != null) {
      setState(() {
        history = saved.map((e) {
          List<String> parts = e.split('|');
          return {'title': parts[0], 'episode': parts[1], 'timestamp': parts[2]};
        }).toList();
      });
    }
  }
  
  Future<void> _saveHistory() async {
    final p = await SharedPreferences.getInstance();
    List<String> encoded = history.map((e) => '${e['title']}|${e['episode']}|${e['timestamp']}').toList();
    await p.setStringList('history', encoded);
  }
  
  void _clearAllHistory() async {
    setState(() => history.clear());
    await _saveHistory();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua riwayat dihapus")));
  }
  
  void _removeHistoryItem(int index) async {
    setState(() => history.removeAt(index));
    await _saveHistory();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Riwayat dihapus")));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text("Riwayat", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            onPressed: history.isEmpty ? null : _clearAllHistory,
          ),
        ],
      ),
      body: history.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text("Belum ada riwayat tontonan", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),
                Text("Drama yang kamu tonton akan muncul di sini", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        : ListView.builder(
            itemCount: history.length,
            itemBuilder: (c, i) => Dismissible(
              key: Key(history[i]['title']),
              background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
              onDismissed: (_) => _removeHistoryItem(i),
              child: ListTile(
                leading: const Icon(Icons.play_circle, color: Color(0xFF8B5CF6)),
                title: Text(history[i]['title'], style: const TextStyle(color: Colors.white)),
                subtitle: Text("Episode ${history[i]['episode']} • ${history[i]['timestamp']}", style: const TextStyle(color: Colors.grey)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _removeHistoryItem(i),
                ),
              ),
            ),
          ),
    );
  }
}

// Halaman Favorit dengan fitur hapus
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});
  @override State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favorites = [];
  
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    final p = await SharedPreferences.getInstance();
    List<String>? saved = p.getStringList('favorites');
    if (saved != null) {
      setState(() {
        favorites = saved.map((e) {
          List<String> parts = e.split('|');
          return {'id': parts[0], 'title': parts[1]};
        }).toList();
      });
    }
  }
  
  Future<void> _saveFavorites() async {
    final p = await SharedPreferences.getInstance();
    List<String> encoded = favorites.map((e) => '${e['id']}|${e['title']}').toList();
    await p.setStringList('favorites', encoded);
  }
  
  void _clearAllFavorites() async {
    setState(() => favorites.clear());
    await _saveFavorites();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua favorit dihapus")));
  }
  
  void _removeFavoriteItem(int index) async {
    setState(() => favorites.removeAt(index));
    await _saveFavorites();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Favorit dihapus")));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text("Favorit", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            onPressed: favorites.isEmpty ? null : _clearAllFavorites,
          ),
        ],
      ),
      body: favorites.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 80, color: Colors.redAccent),
                SizedBox(height: 20),
                Text("Belum ada drama favorit", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),
                Text("Klik ikon hati untuk menambahkan ke favorit", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (c, i) => Dismissible(
              key: Key(favorites[i]['id']),
              background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
              onDismissed: (_) => _removeFavoriteItem(i),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.redAccent),
                title: Text(favorites[i]['title'], style: const TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => _removeFavoriteItem(i),
                ),
              ),
            ),
          ),
    );
  }
}

// SettingsPage dan SourceManager sama seperti sebelumnya...
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool bgPoster = true;
  bool useCache = true;
  bool rotasiManual = false;
  String drm = "Auto";
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      bgPoster = p.getBool('bg_poster') ?? true;
      useCache = p.getBool('use_cache') ?? true;
      rotasiManual = p.getBool('rotasi_manual') ?? false;
      drm = p.getString('drm') ?? "Auto";
    });
  }
  
  Future<void> _saveSetting(String key, dynamic value) async {
    final p = await SharedPreferences.getInstance();
    if (value is bool) {
      await p.setBool(key, value);
    } else if (value is String) {
      await p.setString(key, value);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("TAMPILAN", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSwitchTile(Icons.image, "Background Poster", bgPoster, "Tampilkan poster sebagai background", (v) async {
            setState(() => bgPoster = v);
            await _saveSetting('bg_poster', v);
          }),
          _buildSwitchTile(Icons.cached, "Gunakan Cache", useCache, "Simpan stream agar playback stabil", (v) async {
            setState(() => useCache = v);
            await _saveSetting('use_cache', v);
          }),
          _buildSwitchTile(Icons.rotate_right, "Rotasi Manual", rotasiManual, "Tampilkan tombol rotasi manual", (v) async {
            setState(() => rotasiManual = v);
            await _saveSetting('rotasi_manual', v);
          }),
          const SizedBox(height: 20),
          const Text("PLAYER", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildDrmSelector(),
        ],
      ),
    );
  }
  
  Widget _buildSwitchTile(IconData icon, String title, bool value, String subtitle, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF8B5CF6)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF8B5CF6),
      ),
    );
  }
  
  Widget _buildDrmSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.lock, color: Color(0xFF8B5CF6)),
        title: const Text("Widevine DRM", style: TextStyle(color: Colors.white)),
        subtitle: Text(drm, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _showDrmOptions(),
      ),
    );
  }
  
  void _showDrmOptions() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Widevine DRM", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ["Auto", "Paksa L3", "Berhenti L3"].map((opt) => RadioListTile(
            title: Text(opt, style: const TextStyle(color: Colors.white)),
            value: opt,
            groupValue: drm,
            onChanged: (v) async {
              setState(() => drm = v as String);
              await _saveSetting('drm', v);
              Navigator.pop(c);
            },
          )).toList(),
        ),
      ),
    );
  }
}

class SourceManager extends StatefulWidget {
  const SourceManager({super.key});
  @override State<SourceManager> createState() => _SourceManagerState();
}

class _SourceManagerState extends State<SourceManager> {
  Map<String, bool> sources = {
    "FreeReels": true,
    "Melolo": true,
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text("Sumber Data", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: sources.keys.map((key) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SwitchListTile(
            title: Text(key, style: const TextStyle(color: Colors.white)),
            value: sources[key] ?? true,
            onChanged: (value) {
              setState(() {
                sources[key] = value;
              });
            },
            activeColor: const Color(0xFF8B5CF6),
          ),
        )).toList(),
      ),
    );
  }
}
