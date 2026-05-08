import 'package:flutter/material.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sources = ["Melolo", "DramaBox", "DotDrama", "Netshort", "Stardusttv", "Reelife", "DramaBite", "Velolo"];
  final List<String> cats = ["Populer", "New", "Segera Hadir", "Dubbing", "Trend"];
  String selSource = "Melolo";
  String selCat = "Populer";

  @override
  Widget build(BuildContext context) {
    bool isTV = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildBanner(selSource),
            const SizedBox(height: 15),
            _buildHList(sources, selSource, (v) => setState(() => selSource = v), const Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            _buildHList(cats, selCat, (v) => setState(() => selCat = v), Colors.blueAccent),
            const SizedBox(height: 15),
            _buildGrid(isTV),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(String source) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: TVButton(onTap: (){}, child: Container(height: 170, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white10), alignment: Alignment.center, child: Text("Hot Drama on $source"))),
  );

  Widget _buildHList(List list, String sel, Function(String) onSel, Color color) => SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: list.length, itemBuilder: (c, i) => Padding(padding: const EdgeInsets.only(right: 8), child: TVButton(borderRadius: 20, onTap: () => onSel(list[i]), child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center, decoration: BoxDecoration(color: sel == list[i] ? color : Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text(list[i]))))));

  Widget _buildGrid(bool isTV) => GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(15), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isTV ? 7 : 4, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: isTV ? 14 : 12, itemBuilder: (c, i) => TVButton(onTap: (){}, child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)))));
}
