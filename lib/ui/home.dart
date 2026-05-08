import 'package:flutter/material.dart';
import 'widgets.dart';
import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final List<String> sources = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];
  String selSource = "Melolo";
  @override Widget build(BuildContext context) {
    bool isTV = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF161B22), title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})]),
      body: SingleChildScrollView(child: Column(children: [
        const SizedBox(height: 15),
        TVButton(onTap: (){}, child: Container(height: 180, width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white10), alignment: Alignment.center, child: Text("Banner Drama on $selSource"))),
        const SizedBox(height: 15),
        SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: sources.length, itemBuilder: (c, i) => Padding(padding: const EdgeInsets.only(right: 8), child: TVButton(borderRadius: 20, onTap: () => setState(() => selSource = sources[i]), child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center, decoration: BoxDecoration(color: selSource == sources[i] ? const Color(0xFF8B5CF6) : Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text(sources[i])))))),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(15), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isTV ? 7 : 4, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: isTV ? 14 : 12, itemBuilder: (c, i) => TVButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DetailPage())), child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.white10, size: 30))))),
      ])),
    );
  }
}
