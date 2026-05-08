import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> dramas = [];
  bool isLoading = true;
  String selectedPlatform = 'freereels';
  
  // Dummy data drama (karena API mungkin expired)
  final List<Map<String, dynamic>> dummyDramas = [
    {'id': '1', 'title': 'Menikahi Ayah Mantanku', 'cover': '', 'views': '12.5K', 'chapters': '61', 'status': 'Completed', 'platform': 'freereels'},
    {'id': '2', 'title': 'Cinta Suami Muda Takkan Padam', 'cover': '', 'views': '154.9K', 'chapters': '53', 'status': 'Completed', 'platform': 'freereels'},
    {'id': '3', 'title': 'Balas Dendam Ayah', 'cover': '', 'views': '73.9K', 'chapters': '69', 'status': 'Completed', 'platform': 'freereels'},
    {'id': '4', 'title': 'Istri Masa Depan CEO', 'cover': '', 'views': '45.2K', 'chapters': '48', 'status': 'Ongoing', 'platform': 'freereels'},
    {'id': '5', 'title': 'Jebakan Sang Taipan', 'cover': '', 'views': '23.8K', 'chapters': '32', 'status': 'Completed', 'platform': 'freereels'},
    {'id': '6', 'title': 'Hidup Berjaya Anak Terbuang', 'cover': '', 'views': '89.1K', 'chapters': '78', 'status': 'Completed', 'platform': 'freereels'},
    {'id': '7', 'title': 'Penjalin Hati', 'cover': '', 'views': '34.5K', 'chapters': '45', 'status': 'Ongoing', 'platform': 'freereels'},
    {'id': '8', 'title': 'Sang Master Judi Sejati', 'cover': '', 'views': '67.8K', 'chapters': '82', 'status': 'Completed', 'platform': 'freereels'},
    {'id': '9', 'title': 'Cinta di Balik Warisan', 'cover': '', 'views': '28.9K', 'chapters': '41', 'status': 'Completed', 'platform': 'freereels'},
    {'id': '10', 'title': 'Merebut Kembali Takdir', 'cover': '', 'views': '58.2K', 'chapters': '61', 'status': 'Completed', 'platform': 'melolo'},
    {'id': '11', 'title': 'Drama Melolo 1', 'cover': '', 'views': '12.3K', 'chapters': '30', 'status': 'Completed', 'platform': 'melolo'},
    {'id': '12', 'title': 'Drama Melolo 2', 'cover': '', 'views': '8.7K', 'chapters': '25', 'status': 'Ongoing', 'platform': 'melolo'},
  ];
  
  @override
  void initState() { 
    super.initState(); 
    _loadDramas();
  }
  
  Future<void> _loadDramas() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading
    setState(() {
      dramas = dummyDramas.where((d) => 
        (selectedPlatform == 'freereels' && d['platform'] == 'freereels') ||
        (selectedPlatform == 'melolo' && d['platform'] == 'melolo')
      ).toList();
      isLoading = false;
    });
  }
  
  void _changePlatform(String platform) {
    setState(() {
      selectedPlatform = platform;
      isLoading = true;
    });
    _loadDramas();
  }

  @override
  Widget build(BuildContext context) {
    // Deteksi apakah Android TV atau HP
    bool isAndroidTV = MediaQuery.of(context).size.width > 900;
    int crossAxisCount = isAndroidTV ? 7 : 4;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("CF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(width: 10),
            const Text("CineFlow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur pencarian segera hadir"))
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDramas,
        child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)))
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  Container(
                    height: 180,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Menikahi Ayah Mantanku",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  
                  // Platform Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Text("Platform", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 10),
                        _buildPlatformChip("FreeReels", "freereels"),
                        const SizedBox(width: 8),
                        _buildPlatformChip("Melolo", "melolo"),
                      ],
                    ),
                  ),
                  
                  // Section Title
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "🔥 ${selectedPlatform == 'freereels' ? 'FreeReels' : 'Melolo'} Pilihan",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Lihat Semua >", style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  
                  // Drama Grid - Responsive
                  dramas.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(50),
                        child: Center(child: Text("Tidak ada drama", style: TextStyle(color: Colors.grey))),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(15),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: dramas.length,
                        itemBuilder: (c, i) => _buildDramaCard(dramas[i], isAndroidTV),
                      ),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
      ),
    );
  }
  
  Widget _buildPlatformChip(String label, String platform) {
    return FilterChip(
      label: Text(label),
      selected: selectedPlatform == platform,
      onSelected: (_) => _changePlatform(platform),
      backgroundColor: const Color(0xFF1A1A1A),
      selectedColor: const Color(0xFF8B5CF6),
      labelStyle: TextStyle(
        color: selectedPlatform == platform ? Colors.white : Colors.grey,
        fontSize: 12,
      ),
    );
  }
  
  Widget _buildDramaCard(Map<String, dynamic> drama, bool isAndroidTV) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(drama['title']), duration: const Duration(seconds: 1))
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Container(
                    height: isAndroidTV ? 130 : 140,
                    width: double.infinity,
                    color: const Color(0xFF2A2A2A),
                    child: const Icon(Icons.movie, color: Colors.grey, size: 40),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility, size: 10, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(drama['views'], style: const TextStyle(fontSize: 9, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drama['title'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${drama['chapters']} eps",
                          style: const TextStyle(fontSize: 9, color: Color(0xFF8B5CF6)),
                        ),
                      ),
                      if (drama['status'] == 'Completed') ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text("Selesai", style: TextStyle(fontSize: 9, color: Colors.green)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
