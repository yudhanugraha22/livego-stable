import 'package:flutter/material.dart';

void main() => runApp(const LivegoApp());

class LivegoApp extends StatelessWidget {
  const LivegoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117), // Hitam CineFlow
        primaryColor: const Color(0xFF8B5CF6), // Ungu Accents
      ),
      home: const CineFlowHome(),
    );
  }
}

class CineFlowHome extends StatefulWidget {
  const CineFlowHome({super.key});
  @override
  State<CineFlowHome> createState() => _CineFlowHomeState();
}

class _CineFlowHomeState extends State<CineFlowHome> {
  String selectedSource = "FreeReels";
  String selectedCategory = "Populer";

  final List<String> sources = ["FreeReels", "Moviebox", "Anichin", "Animelovers", "Melolo", "Reelshort"];
  final List<String> categories = ["Populer", "New", "Segera Hadir", "Dubbing", "Perempuan", "Laki-Laki"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        title: const Text("Livego", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(icon: const Icon(Icons.history_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            // BANNER UTAMA
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/600x300/1e293b/ffffff?text=Featured+Drama"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(5)),
                      child: const Text("FREEREELS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 5),
                    const Text("Dari Anak Haram ke Raja Dunia Bawah(Sulih Suara)", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // TAB UTAMA (FreeReels, dll)
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: sources.length,
                itemBuilder: (context, i) {
                  bool isSelected = selectedSource == sources[i];
                  return GestureDetector(
                    onTap: () => setState(() => selectedSource = sources[i]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF8B5CF6) : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(sources[i], style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // TAB KATEGORI (Populer, New, dll)
            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: categories.length,
                itemBuilder: (context, i) {
                  bool isSelected = selectedCategory == categories[i];
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = categories[i]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0EA5E9) : Colors.white10,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isSelected ? Colors.cyan : Colors.transparent),
                      ),
                      alignment: Alignment.center,
                      child: Text(categories[i], style: const TextStyle(fontSize: 12)),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // GRID KONTEN
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 9,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: NetworkImage("https://via.placeholder.com/200x300/334155/ffffff"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Label EP (Kiri Atas)
                          Positioned(
                            top: 5, left: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                              child: const Text("1 Ep", style: TextStyle(fontSize: 8)),
                            ),
                          ),
                          // Label Views (Kanan Atas)
                          Positioned(
                            top: 5, right: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                              child: const Text("18.9M", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text("Cinta Bos Geng Untuk Gadis...", 
                      maxLines: 2, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF161B22),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.download_for_offline_rounded), label: "UNDUHAN"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "AKUN"),
        ],
      ),
    );
  }
}
