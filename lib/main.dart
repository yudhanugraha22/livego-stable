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

// --- KOMPONEN KURSOR TV NEON ---
class TVButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const TVButton({super.key, required this.child, required this.onTap});
  @override State<TVButton> createState() => _TVButtonState();
}
class _TVButtonState extends State<TVButton> {
  bool _isF = false;
  @override Widget build(BuildContext context) {
    return Focus(onFocusChange: (f)=>setState(()=>_isF=f), child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 150), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: _isF ? Colors.blueAccent : Colors.transparent, width: 3.5), boxShadow: _isF ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.8), blurRadius: 20, spreadRadius: 3)] : []), transform: _isF ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(), child: widget.child)));
  }
}

// --- NAVIGASI UTAMA & EXIT DIALOG ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _idx = 0;
  Map<String, bool> apis = {"Melolo":true,"DramaBox":true,"DotDrama":true,"Netshort":true,"Stardusttv":true,"Reelife":true,"DramaBite":true,"Velolo":true};

  Future<void> _exit() async {
    final c = await getTemporaryDirectory();
    if (c.existsSync()) c.deleteSync(recursive: true);
    SystemNavigator.pop();
  }

  void _showExit() {
    showDialog(context: context, builder: (c)=>AlertDialog(backgroundColor: const Color(0xFF161B22), title: const Text("Keluar & Bersihkan Cache?"), actions: [TextButton(onPressed: ()=>Navigator.pop(c), child: const Text("Batal")), ElevatedButton(onPressed: _exit, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Keluar"))]));
  }

  @override Widget build(BuildContext context) {
    return PopScope(canPop: false, onPopInvokedWithResult: (did, res) { if(!did) _showExit(); }, 
      child: Scaffold(
        body: IndexedStack(index: _idx, children: [HomePage(apis: apis), const Center(child: Text("Halaman Unduhan")), AccountPage(apis: apis, onCh: (v)=>setState(()=>apis=v))]),
        bottomNavigationBar: BottomNavigationBar(currentIndex: _idx, onTap: (i)=>setState(()=>_idx=i), backgroundColor: const Color(0xFF161B22), selectedItemColor: Colors.blueAccent, type: BottomNavigationBarType.fixed, items: const [BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"), BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: "UNDUHAN"), BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN")]),
      )
    );
  }
}

// --- 1. HALAMAN HOME (BANNER + 8 API + CATEGORY + GRID 7x2) ---
class HomePage extends StatefulWidget {
  final Map<String, bool> apis;
  const HomePage({super.key, required this.apis});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String selSource = "Melolo";
  String selCat = "Populer";
  @override Widget build(BuildContext context) {
    bool isT = MediaQuery.of(context).size.width > 900;
    List<String> active = widget.apis.entries.where((e)=>e.value).map((e)=>e.key).toList();
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF161B22), elevation: 0, title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)), actions: [IconButton(icon: const Icon(Icons.search), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (c)=>const SearchPage())))]),
      body: SingleChildScrollView(child: Column(children: [
        const SizedBox(height: 15),
        _banner(),
        const SizedBox(height: 15),
        _hList(active, selSource, (v)=>setState(()=>selSource=v), const Color(0xFF8B5CF6)), // 8 API (Ungu)
        const SizedBox(height: 10),
        _hList(["Populer", "New", "Segera Hadir", "Dubbing", "Trend"], selCat, (v)=>setState(()=>selCat=v), Colors.blueAccent), // Kategori (Biru)
        _grid(isT),
      ])),
    );
  }
  Widget _banner() => Container(margin: const EdgeInsets.symmetric(horizontal: 15), child: TVButton(onTap: (){}, child: Container(height: 170, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/600x300/1e293b/ffffff?text=Feature+Drama"), fit: BoxFit.cover)), alignment: Alignment.bottomLeft, padding: const EdgeInsets.all(15), child: Text("Hot Drama on $selSource", style: const TextStyle(fontWeight: FontWeight.bold)))));
  Widget _hList(List l, String s, Function(String) o, Color c) => SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 15), itemCount: l.length, itemBuilder: (ctx, i)=>Padding(padding: const EdgeInsets.only(right: 8), child: TVButton(onTap: ()=>o(l[i]), child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center, decoration: BoxDecoration(color: s == l[i] ? c : Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text(l[i], style: const TextStyle(fontSize: 12)))))));
  Widget _grid(bool isT) => GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(15), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isT?7:4, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: isT?14:12, itemBuilder: (c, i) => TVButton(onTap: (){}, child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.white10, size: 30)))));
}

// --- 2. HALAMAN AKUN & 3. PENGATURAN (10 POIN LENGKAP) ---
class AccountPage extends StatefulWidget {
  final Map<String, bool> apis;
  final Function(Map<String, bool>) onCh;
  const AccountPage({super.key, required this.apis, required this.onCh});
  @override State<AccountPage> createState() => _AccountPageState();
}
class _AccountPageState extends State<AccountPage> {
  String nav = "Otomatis (Ikuti Hardware)", drm = "Auto";
  bool bg = false, cache = true, rot = true;

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(15), children: [
        const SizedBox(height: 40),
        _card([ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, color: Colors.white)), title: const Text("User Penggemar"), subtitle: const Text("Akun CineFlow"))]),
        const SizedBox(height: 20),
        _label("KOLEKSI CEPAT"),
        _card([
          _item(Icons.history, "Riwayat", "Lanjutkan tontonan", ()=>_goList("Riwayat")), // Poin 1
          _item(Icons.favorite_border, "Favorit", "Drama yang disimpan", ()=>_goList("Favorit")), // Poin 2
        ]),
        const SizedBox(height: 20),
        _label("PENGATURAN SISTEM"),
        _card([
          _item(Icons.settings, "Navigasi Hardware", nav, ()=>_showNav()), // Poin 3
          _switch(Icons.image, "Background Poster", bg, (v)=>setState(()=>bg=v)), // Poin 4
          _switch(Icons.cached, "Gunakan Cache", cache, (v)=>setState(()=>cache=v)), // Poin 5
          _switch(Icons.screen_rotation, "Rotasi Manual", rot, (v)=>setState(()=>rot=v)), // Poin 6
          _item(Icons.lock, "Widevine DRM", drm, ()=>_showDRM()), // Poin 7
          _item(Icons.layers, "Kelola Sumber Data", "8 API Aktif", ()=>_goAPI()), // Poin 8
        ]),
        const SizedBox(height: 20),
        _label("DUKUNGAN"),
        _card([
          _item(Icons.system_update, "Periksa Pembaruan", "Versi 1.0.0", ()=>_showMsg("Aplikasi sudah versi terbaru")), // Poin 9
          _item(Icons.message, "Feedback & Dukungan", "Hubungi Developer", ()=>_showMsg("Fitur kirim pesan segera hadir")), // Poin 10
        ]),
        const SizedBox(height: 40),
      ]),
    );
  }

  void _showNav() => showDialog(context: context, builder: (c)=>AlertDialog(title: const Text("Navigasi"), backgroundColor: const Color(0xFF161B22), content: Column(mainAxisSize: MainAxisSize.min, children: ["Otomatis (Ikuti Hardware)", "Smartphone / Tablet", "Android TV"].map((v)=>RadioListTile(title: Text(v), value: v, groupValue: nav, onChanged: (x){setState(()=>nav=x!); Navigator.pop(c);})).toList())));
  void _showDRM() => showDialog(context: context, builder: (c)=>AlertDialog(title: const Text("DRM Mode"), backgroundColor: const Color(0xFF161B22), content: Column(mainAxisSize: MainAxisSize.min, children: ["Auto", "Paksa L3", "Berhenti L3"].map((v)=>RadioListTile(title: Text(v), value: v, groupValue: drm, onChanged: (x){setState(()=>drm=x!); Navigator.pop(c);})).toList())));
  void _goAPI() => Navigator.push(context, MaterialPageRoute(builder: (c)=>SourceManager(apis: widget.apis, onCh: widget.onCh)));
  void _goList(String t) => Navigator.push(context, MaterialPageRoute(builder: (c)=>Scaffold(appBar: AppBar(title: Text(t)), body: Center(child: Text("Daftar $t Kosong")))));
  void _showMsg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)));
  Widget _card(List<Widget> i) => Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: i));
  Widget _item(IconData i, String t, String s, VoidCallback click) => TVButton(onTap: click, child: ListTile(leading: Icon(i, color: Colors.white70), title: Text(t, style: const TextStyle(fontSize: 14)), subtitle: Text(s, style: const TextStyle(fontSize: 11, color: Colors.blueAccent)), trailing: const Icon(Icons.chevron_right, size: 16)));
  Widget _switch(IconData i, String t, bool v, Function(bool) c) => TVButton(onTap: ()=>c(!v), child: SwitchListTile(secondary: Icon(i, color: Colors.white70), title: Text(t, style: const TextStyle(fontSize: 14)), value: v, onChanged: c, activeColor: Colors.blueAccent));
}

class SourceManager extends StatefulWidget {
  final Map<String, bool> apis;
  final Function(Map<String, bool>) onCh;
  const SourceManager({super.key, required this.apis, required this.onCh});
  @override State<SourceManager> createState() => _SourceManagerState();
}
class _SourceManagerState extends State<SourceManager> {
  late Map<String, bool> s;
  @override void initState() { super.initState(); s = Map.from(widget.apis); }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Kelola Sumber Data"), backgroundColor: const Color(0xFF161B22)), body: ListView(padding: const EdgeInsets.all(15), children: s.keys.map((k)=>Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)), child: TVButton(onTap: (){setState(()=>s[k]=!s[k]!); widget.onCh(s);}, child: SwitchListTile(title: Text(k), value: s[k]!, onChanged: (v){setState(()=>s[k]=v); widget.onCh(s);}, activeColor: Colors.blueAccent)))).toList()));
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const TextField(autofocus: true, decoration: InputDecoration(hintText: "Cari Dracin...", border: InputBorder.none))), body: const Center(child: Text("Hasil pencarian")));
  }
}
