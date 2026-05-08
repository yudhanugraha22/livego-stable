import 'package:flutter/material.dart';
import 'widgets.dart';

class AccountPage extends StatefulWidget {
  final Map<String, bool> apis;
  final Function(Map<String, bool>) onCh;
  const AccountPage({super.key, required this.apis, required this.onCh});
  @override State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String nav = "Otomatis", drm = "Auto";
  bool bg = false, cache = true, rot = true;

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(15), children: [
        const SizedBox(height: 40),
        _card([ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, color: Colors.white)), title: const Text("User Penggemar"), subtitle: const Text("Akun CineFlow"))]),
        const SizedBox(height: 20),
        _label("KOLEKSI"),
        _card([_item(Icons.history, "Riwayat", "Lihat tontonan"), _item(Icons.favorite, "Favorit", "Drama simpan")]),
        const SizedBox(height: 20),
        _label("PENGATURAN SISTEM"),
        _card([
          _item(Icons.settings, "Navigasi Hardware", nav, click: _showNav),
          _switch(Icons.image, "Background Poster", bg, (v)=>setState(()=>bg=v)),
          _switch(Icons.cached, "Gunakan Cache", cache, (v)=>setState(()=>cache=v)),
          _switch(Icons.screen_rotation, "Rotasi Manual", rot, (v)=>setState(()=>rot=v)),
          _item(Icons.lock, "Widevine DRM", drm, click: _showDRM),
          _item(Icons.layers, "Kelola Sumber Data", "8 API Aktif", click: _goAPI),
        ]),
        const SizedBox(height: 20),
        _label("DUKUNGAN"),
        _card([_item(Icons.update, "Cek Pembaruan", "v1.0.0"), _item(Icons.message, "Feedback", "Hubungi Developer")]),
      ]),
    );
  }

  void _showNav() => showDialog(context: context, builder: (c)=>AlertDialog(title: const Text("Navigasi"), backgroundColor: const Color(0xFF161B22), content: Column(mainAxisSize: MainAxisSize.min, children: ["Otomatis", "Smartphone", "Android TV"].map((v)=>RadioListTile(title: Text(v), value: v, groupValue: nav, onChanged: (x){setState(()=>nav=x!); Navigator.pop(c);})).toList())));
  void _showDRM() => showDialog(context: context, builder: (c)=>AlertDialog(title: const Text("DRM"), backgroundColor: const Color(0xFF161B22), content: Column(mainAxisSize: MainAxisSize.min, children: ["Auto", "Paksa L3", "Berhenti L3"].map((v)=>RadioListTile(title: Text(v), value: v, groupValue: drm, onChanged: (x){setState(()=>drm=x!); Navigator.pop(c);})).toList())));
  void _goAPI() => Navigator.push(context, MaterialPageRoute(builder: (c)=>SourceManager(apis: widget.apis, onCh: widget.onCh)));
  Widget _label(String t) => Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)));
  Widget _card(List<Widget> i) => Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: i));
  Widget _item(IconData i, String t, String s, {VoidCallback? click}) => TVButton(onTap: click??(){}, child: ListTile(leading: Icon(i), title: Text(t), subtitle: Text(s, style: const TextStyle(fontSize: 11, color: Colors.blueAccent)), trailing: const Icon(Icons.chevron_right, size: 16)));
  Widget _switch(IconData i, String t, bool v, Function(bool) c) => TVButton(onTap: ()=>c(!v), child: SwitchListTile(secondary: Icon(i), title: Text(t), value: v, onChanged: c, activeColor: Colors.blueAccent));
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
    return Scaffold(appBar: AppBar(title: const Text("Sumber Data")), body: ListView(padding: const EdgeInsets.all(15), children: s.keys.map((k)=>Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)), child: TVButton(onTap: (){setState(()=>s[k]=!s[k]!); widget.onCh(s);}, child: SwitchListTile(title: Text(k), value: s[k]!, onChanged: (v){setState(()=>s[k]=v); widget.onCh(s);}, activeColor: Colors.blueAccent)))).toList()));
  }
}
