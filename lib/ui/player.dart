import 'package:flutter/material.dart';
import 'widgets.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        const Center(child: Icon(Icons.play_circle_fill, size: 80, color: Colors.white54)),
        Positioned(top: 40, left: 20, child: TVButton(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 30))),
        Positioned(bottom: 50, left: 20, right: 20, child: Column(children: [
          const LinearProgressIndicator(value: 0.3, backgroundColor: Colors.white24, color: Colors.blueAccent),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TVButton(onTap: (){}, child: const Icon(Icons.skip_previous, size: 40)),
            const SizedBox(width: 30),
            TVButton(onTap: (){}, child: const Icon(Icons.play_arrow, size: 60)),
            const SizedBox(width: 30),
            TVButton(onTap: (){}, child: const Icon(Icons.skip_next, size: 40)),
          ])
        ]))
      ]),
    );
  }
}
