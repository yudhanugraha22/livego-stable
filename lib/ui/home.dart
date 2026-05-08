import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/drama_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> dramas = [];
  List<dynamic> banners = [];
  bool isLoading = true;
  String selectedCategory = 'freereels';
  int currentBannerIndex = 0;
  
  final List<Map<String, String>> categories = [
    {'id': 'freereels', 'name': 'FreeReels', 'icon': '🎬'},
    {'id': 'melolo', 'name': 'Melolo', 'icon': '🎭'},
  ];
  
  @override
  void initState() { 
    super.initState(); 
    _fetchData();
  }
  
  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _fetchDramas(),
      _fetchBanners(),
    ]);
    setState(() => isLoading = false);
  }
  
  Future<void> _fetchDramas() async {
    dramas = await DramaAPI.getHome(selectedCategory, 'id');
  }
  
  Future<void> _fetchBanners() async {
    // Banner bisa dari API atau dummy
    banners = [
      {'title': 'Menikahi Ayah Mantanku', 'image': ''},
      {'title': 'Cinta Suami Muda', 'image': ''},
    ];
  }
  
  void _changeCategory(String categoryId) async {
    setState(() {
      selectedCategory = categoryId;
      isLoading = true;
    });
    await _fetchDramas();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchPage()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)))
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Carousel
                  if (banners.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: banners.length,
                        onPageChanged: (index) => setState(() => currentBannerIndex = index),
                        itemBuilder: (ctx, i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              banners[i]['title'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Category Chips
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Text("Platform", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 10),
                        ...categories.map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FilterChip(
                            label: Text("${cat['icon']} ${cat['name']}"),
                            selected: selectedCategory == cat['id'],
                            onSelected: (_) => _changeCategory(cat['id']!),
                            backgroundColor: const Color(0xFF1A1A1A),
                            selectedColor: const Color(0xFF8B5CF6),
                            labelStyle: TextStyle(
                              color: selectedCategory == cat['id'] ? Colors.white : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        )),
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
                          "🔥 ${selectedCategory == 'freereels' ? 'FreeReels' : 'Melolo'} Pilihan",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Lihat Semua >", style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  
                  // Drama Grid
                  dramas.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(50),
                        child: Center(child: Text("Tidak ada drama", style: TextStyle(color: Colors.grey))),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(15),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: dramas.length > 10 ? 10 : dramas.length,
                        itemBuilder: (c, i) => _buildDramaCard(dramas[i]),
                      ),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
      ),
    );
  }
  
  Widget _buildDramaCard(dynamic drama) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(drama['title'] ?? 'Drama'), duration: const Duration(seconds: 1))
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
                  Image.network(
                    drama['cover'] ?? '',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.movie, color: Colors.grey, size: 40),
                    ),
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
                          Text(_formatViews(drama['views']), style: const TextStyle(fontSize: 9, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drama['title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
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
                          "${drama['chapters'] ?? 0} eps",
                          style: const TextStyle(fontSize: 9, color: Color(0xFF8B5CF6)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (drama['status'] == 'Completed')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text("Selesai", style: TextStyle(fontSize: 9, color: Colors.green)),
                        ),
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
  
  String _formatViews(dynamic views) {
    if (views == null) return '0';
    String v = views.toString();
    if (v.contains('M')) return v;
    if (v.length > 6) return '${(int.parse(v) / 1000000).toStringAsFixed(1)}M';
    if (v.length > 3) return '${(int.parse(v) / 1000).toStringAsFixed(0)}K';
    return v;
  }
}

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> results = [];
  bool isLoading = false;
  String selectedCategory = 'freereels';
  
  final List<Map<String, String>> categories = [
    {'id': 'freereels', 'name': 'FreeReels'},
    {'id': 'melolo', 'name': 'Melolo'},
  ];
  
  Future<void> _search() async {
    if (_controller.text.isEmpty) return;
    setState(() => isLoading = true);
    results = await DramaAPI.search(selectedCategory, _controller.text, 'id');
    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          onSubmitted: (_) => _search(),
          decoration: InputDecoration(
            hintText: "Cari judul drama...",
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFF1A1A1A),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Text("Cari di: ", style: TextStyle(color: Colors.white70)),
                ...categories.map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(cat['name']!),
                    selected: selectedCategory == cat['id'],
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = cat['id']!;
                        results = [];
                      });
                    },
                    backgroundColor: const Color(0xFF1A1A1A),
                    selectedColor: const Color(0xFF8B5CF6),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)))
              : results.isEmpty
                ? const Center(child: Text("Ketik judul drama yang ingin dicari", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (c, i) => ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          results[i]['cover'] ?? '',
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 50, height: 70, color: const Color(0xFF1A1A1A), child: const Icon(Icons.movie)),
                        ),
                      ),
                      title: Text(results[i]['title'] ?? '', style: const TextStyle(color: Colors.white)),
                      subtitle: Text("${results[i]['views'] ?? 0} views • ${results[i]['chapters'] ?? 0} eps", style: const TextStyle(color: Colors.grey)),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(results[i]['title'] ?? 'Drama'))
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
