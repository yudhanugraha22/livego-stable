import 'package:flutter/material.dart';
import 'widgets.dart';
import 'player.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF161B22), title: const Text("Detail Drama")),
      body: SingleChildScrollView(child: Column(children: [
        Container(height: 250, color: Colors.white10, alignment: Alignment.center, child: const Icon(Icons.movie, size: 100)),
        const Padding(padding: EdgeInsets.all(15), child: Text("Judul Drama China - Episode 1/75", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Text("Deskripsi singkat drama akan muncul di sini sesuai data dari API.")),
        const SizedBox(height: 20),
        const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.only(left: 15), child: Text("DAFTAR EPISODE", style: TextStyle(fontWeight: FontWeight.bold)))),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(15), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10), itemCount: 75, itemBuilder: (c, i) => TVButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const PlayerPage())), child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Text("${i+1}"))))
      ])),
    );
  }
}
