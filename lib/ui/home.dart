import 'package:flutter/material.dart';
import 'widgets.dart';

class HomePage extends StatelessWidget {
  final Map<String, bool> apis;
  const HomePage({super.key, required this.apis});
  @override Widget build(BuildContext context) {
    bool isT = MediaQuery.of(context).size.width > 900;
    List<String> active = apis.entries.where((e)=>e.value).map((e)=>e.key).toList();
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF161B22), title: const Text("Livego", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(child: Column(children: [
        const SizedBox(height: 10),
        SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 15), itemCount: active.length, itemBuilder: (ctx, i)=>Padding(padding: const EdgeInsets.only(right: 8), child: TVButton(onTap: (){}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20), alignment: Alignment.center, decoration: BoxDecoration(color: i==0?const Color(0xFF8B5CF6):Colors.white10, borderRadius: BorderRadius.circular(20)), child: Text(active[i])))))),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(15), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isT?7:4, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: isT?14:12, itemBuilder: (c, i) => TVButton(onTap: (){}, child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.play_arrow, color: Colors.white10)))),
      ])),
    );
  }
}
