import 'package:flutter/material.dart';

void main() => runApp(const LivegoApp());

class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Warna Biru Gelap Mewah
        primaryColor: Colors.blueAccent,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _activeSource = "Melolo";
  
  // Daftar 8 API Anda
  final List<String> _sources = [
    "Melolo", "DramaBox", "ReelShort", "NetShort", 
    "FlickReels", "DramaWave", "DotDrama", "GoodShort"
  ];

  @override
  Widget build(BuildContext context) {
    // Cek apakah mode Landscape (TV) atau Portrait (HP)
    bool isTV = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("LIVEGO", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.blueAccent)),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Pilihan Sumber (8 API)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _sources.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_sources[i]),
                    selected: _activeSource == _sources[i],
                    onSelected: (val) => setState(() => _activeSource = _sources[i]),
                    selectedColor: Colors.blueAccent,
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Populer Hari Ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          // Grid Daftar Drama
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTV ? 6 : 3, // Lebih banyak kolom di TV
                childAspectRatio: 0.65,
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: NetworkImage("https://via.placeholder.com/200x300/1e293b/ffffff?text=Poster"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5, right: 5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                                child: const Text("HD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text("Judul Drama Dracin...", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: "Unduhan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}
