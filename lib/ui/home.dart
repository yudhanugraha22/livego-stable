import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<String> activeApis = [];
  @override void initState() { super.initState(); _load(); }
  _load() async {
    final p = await SharedPreferences.getInstance();
    List<String> all = ["Melolo","DramaBox","DotDrama","Netshort","Stardusttv","Reelife","DramaBite","Velolo"];
    setState(() { activeApis = all.where((k) => p.getBool('api_$k') ?? true).toList(); });
  }

  @override Widget build(BuildContext context) {
    bool isT = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF161B22), title: const Text("Livego", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))),
      body: ListView(children: [
        const SizedBox(height: 10),
        TVButton(onTap: (){}, child: Container(height: 170, margin: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: const Center(child: Text("Banner Drama")))),
        SizedBox(height: 45, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 15), itemCount: activeApis.length, itemBuilder: (ctx, i)=>Padding(padding: const EdgeInsets.only(right: 8), child: TVButton(onTap: (){}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center, decoration: BoxDecoration(color: i==0?const Color(0xFF8B5CF6):Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text(activeApis[i])))))),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(15), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isT?7:4, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: isT?14:12, itemBuilder: (c, i) => TVButton(onTap: (){}, child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.play_arrow, color: Colors.white10)))),
      ]),
    );
  }
}
