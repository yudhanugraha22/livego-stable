import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/drama_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> dramas = [];
  bool isLoading = true;
  String selectedCategory = 'freereels';
  
  final List<Map<String, String>> categories = [
    {'id': 'freereels', 'name': 'FreeReels'},
    {'id': 'melolo', 'name': 'Melolo'},
  ];
  
  @override
  void initState() { 
    super.initState(); 
    _fetchDramas();
  }
  
  Future<void> _fetchDramas() async {
    setState(() => isLoading = true);
    dramas = await DramaAPI.getHome(selectedCategory, 'id');
    setState(() => isLoading = false);
  }
  
  void _changeCategory(String categoryId) async {
    setState(() {
      selectedCategory = categoryId;
      isLoading = true;
    });
    await _fetchDramas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Livego", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category selector
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  label: Text(categories[i]['name']!),
                  selected: selectedCategory == categories[i]['id'],
                  onSelected: (_) => _changeCategory(categories[i]['id']!),
                  backgroundColor: Colors.white10,
                  selectedColor: const Color(0xFF8B5CF6),
                  labelStyle: TextStyle(
                    color: selectedCategory == categories[i]['id'] ? Colors.white : Colors.grey
                  ),
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)))
              : dramas.isEmpty
                ? const Center(child: Text("Tidak ada drama", style: TextStyle(color: Colors.grey)))
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: dramas.length > 20 ? 20 : dramas.length,
                    itemBuilder: (c, i) => _buildDramaCard(dramas[i]),
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDramaCard(dynamic drama) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(drama['title'] ?? 'Drama'))
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                drama['cover'] ?? '',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.grey, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drama['title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${drama['views'] ?? '0'} views',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
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

// Halaman Pencarian
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          onSubmitted: (_) => _search(),
          decoration: const InputDecoration(
            hintText: "Cari drama...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  label: Text(categories[i]['name']!),
                  selected: selectedCategory == categories[i]['id'],
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = categories[i]['id']!;
                      results = [];
                    });
                  },
                  backgroundColor: Colors.white10,
                  selectedColor: const Color(0xFF8B5CF6),
                ),
              ),
            ),
          ),
          // Search button
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: _search,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text("CARI", style: TextStyle(color: Colors.white)),
            ),
          ),
          // Results
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : results.isEmpty
                ? const Center(child: Text("Ketik judul dan tekan cari", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (c, i) => ListTile(
                      leading: const Icon(Icons.movie, color: Color(0xFF8B5CF6)),
                      title: Text(results[i]['title'] ?? 'No Title', style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${results[i]['views'] ?? 0} views', style: const TextStyle(color: Colors.grey)),
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
