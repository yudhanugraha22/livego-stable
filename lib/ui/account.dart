import 'package:flutter/material.dart';
import 'widgets.dart';

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
            _menuSection(context, "KOLEKSI CEPAT", [
              _item(context, Icons.history, "Riwayat", "Lanjutkan tontonan"),
              _item(context, Icons.favorite_border, "Favorit", "Daftar drama disimpan"),
              _item(context, Icons.settings, "Pengaturan", "Player & DRM", isSet: true),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(25)), child: Row(children: [const CircleAvatar(radius: 30, backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, color: Colors.white)), const SizedBox(width: 15), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text("Akun CineFlow", style: TextStyle(color: Colors.grey))])]));

  Widget _menuSection(BuildContext ctx, String t, List<Widget> items) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.only(left: 10, bottom: 10), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))), Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: items))]);

  Widget _item(BuildContext ctx, IconData i, String t, String s, {bool isSet = false}) => TVButton(onTap: () { if(isSet) Navigator.push(ctx, MaterialPageRoute(builder: (c) => const Scaffold(appBar: AppBar(title: Text("Pengaturan"))))); }, child: ListTile(leading: Icon(i), title: Text(t), subtitle: Text(s, style: const TextStyle(fontSize: 11)), trailing: const Icon(Icons.chevron_right)));
}
