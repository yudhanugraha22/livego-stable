import 'package:flutter/material.dart';
import 'widgets.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(padding: const EdgeInsets.all(15), child: Column(children: [
      const SizedBox(height: 50),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(25)), child: Row(children: [const CircleAvatar(radius: 35, backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, color: Colors.white, size: 40)), const SizedBox(width: 15), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text("Akun CineFlow", style: TextStyle(color: Colors.grey))])])),
      const SizedBox(height: 25),
      _group("KOLEKSI CEPAT", [ _item(Icons.history, "Riwayat"), _item(Icons.favorite_border, "Favorit"), _item(Icons.settings, "Pengaturan") ]),
    ])));
  }
  Widget _group(String t, List<Widget> i) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.only(left: 10, bottom: 8), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))), Container(decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)), child: Column(children: i))]);
  Widget _item(IconData i, String t) => TVButton(onTap: (){}, child: ListTile(leading: Icon(i, color: Colors.white70), title: Text(t), trailing: const Icon(Icons.chevron_right, size: 18)));
}
