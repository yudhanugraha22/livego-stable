import 'package:flutter/material.dart';
import 'widgets.dart';
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(padding: const EdgeInsets.all(15), child: Column(children: [
        const SizedBox(height: 50),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(25)), child: const Row(children: [CircleAvatar(radius: 30, backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.play_arrow, color: Colors.white)), SizedBox(width: 15), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("User Penggemar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text("Akun CineFlow", style: TextStyle(color: Colors.grey))])])),
        const SizedBox(height: 25),
        TVButton(onTap: (){}, child: const ListTile(leading: Icon(Icons.settings), title: Text("Pengaturan"))),
      ])),
    );
  }
}
