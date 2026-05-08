import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String nav = "Otomatis", drm = "Auto";
  bool bg = false, cache = true, rot = true;

  @override
  void initState() { super.initState(); _loadSettings(); }

  // LOAD DATA DARI MEMORI HP
  _loadSettings() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      nav = p.getString('nav') ?? "Otomatis";
      drm = p.getString('drm') ?? "Auto";
      bg = p.getBool('bg') ?? false;
      cache = p.getBool('cache') ?? true;
      rot = p.getBool('rot') ?? true;
    });
  }

  // SIMPAN DATA KE MEMORI HP
  _save(String k, dynamic v) async {
    final p = await SharedPreferences.getInstance();
    if (v is String) p.setString(k, v);
    if (v is bool) p.setBool(k, v);
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(15), children: [
        const SizedBox(height: 40),
        _card([ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, color: Colors.white)), title: const Text("User Penggemar"), subtitle: const Text("Akun CineFlow"))]),
        const SizedBox(height: 20),
        _label("PENGATURAN SISTEM"),
        _card([
          _item(Icons.settings, "Navigasi Hardware", nav, ()=>_showNav()),
          _switch(Icons.image, "Background Poster", bg, (v){ setState(()=>bg=v); _save('bg',v); }),
          _switch(Icons.cached, "Gunakan Cache", cache, (v){ setState(()=>cache=v); _save('cache',v); }),
          _switch(Icons.screen_rotation, "Rotasi Manual", rot, (v){ setState(()=>rot=v); _save('rot',v); }),
          _item(Icons.lock, "Widevine DRM", drm, ()=>_showDRM()),
          _item(Icons.layers, "Kelola Sumber Data", "8 API Aktif", ()=>_goAPI()),
        ]),
        const SizedBox(height: 20),
        _label("DUKUNGAN"),
        _card([_item(Icons.update, "Cek Pembaruan", "v1.0.0", (){}), _item(Icons.message, "Feedback", "Hubungi Developer", (){})]),
      ]),
    );
  }

  void _showNav() => _dialog("Navigasi", ["Otomatis", "Smartphone", "Android TV"], nav, (v){ setState(()=>nav=v); _save('nav',v); });
  void _showDRM() => _dialog("DRM", ["Auto", "Paksa L3", "Berhenti L3"], drm, (v){ setState(()=>drm=v); _save('drm',v); });
  
  void _dialog(String t, List<String> o, String g, Function(String) s) => showDialog(context: context, builder: (c)=>AlertDialog(title: Text(t), backgroundColor: const Color(0xFF161B22), content: Column(mainAxisSize: MainAxisSize.min, children: o.map((v)=>RadioListTile(title: Text(v), value: v, groupValue: g, onChanged: (x){s(x!); Navigator.pop(c);})).toList())));
  void _goAPI() => Navigator.push(context, MaterialPageRoute(builder: (c)=>const SourceManager()));
  Widget _label(String t) => Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)));
  Widget _card(List<Widget> i) => Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: i));
  Widget _item(IconData i, String t, String s, VoidCallback click) => TVButton(onTap: click, child: ListTile(leading: Icon(i, color: Colors.white70), title: Text(t, style: const TextStyle(fontSize: 14)), subtitle: Text(s, style: const TextStyle(fontSize: 11, color: Colors.blueAccent)), trailing: const Icon(Icons.chevron_right, size: 16)));
  Widget _switch(IconData i, String t, bool v, Function(bool) c) => TVButton(onTap: ()=>c(!v), child: SwitchListTile(secondary: Icon(i, color: Colors.white70), title: Text(t, style: const TextStyle(fontSize: 14)), value: v, onChanged: c, activeColor: Colors.blueAccent));
}

class SourceManager extends StatefulWidget {
  const SourceManager({super.key});
  @override State<SourceManager> createState() => _SourceManagerState();
}
class _SourceManagerState extends State<SourceManager> {
  Map<String, bool> s = {"Melolo":true,"DramaBox":true,"DotDrama":true,"Netshort":true,"Stardusttv":true,"Reelife":true,"DramaBite":true,"FreeReels":true};
  @override void initState() { super.initState(); _load(); }
  _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() { s.forEach((k, v) { s[k] = p.getBool('api_$k') ?? true; }); });
  }
  _save(String k, bool v) async { final p = await SharedPreferences.getInstance(); p.setBool('api_$k', v); }

  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Sumber Data")), body: ListView(padding: const EdgeInsets.all(15), children: s.keys.map((k)=>Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(15)), child: TVButton(onTap: (){ setState(()=>s[k]=!s[k]!); _save(k, s[k]!); }, child: SwitchListTile(title: Text(k), value: s[k]!, onChanged: (v){ setState(()=>s[k]=v); _save(k,v); }, activeColor: Colors.blueAccent)))).toList()));
  }
}
