import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/drama_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> activeApis = [];
  List<dynamic> dramas = [];
  bool isLoading = true;
  String selectedCategory = 'freereels';
  
  final List<Map<String, String>> availableApis = [
    {'id': 'freereels', 'name': 'FreeReels'},
    {'id': 'melolo', 'name': 'Melolo'},
  ];
  
  @override
  void initState() { 
    super.initState(); 
    _load();
    _fetchDramas();
  }
  
  _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() { 
      activeApis = availableApis.where((api) => p.getBool('api_${api['id']}') ?? true).map((e) => e['name']!).toList();
    });
  }
  
  Future<void> _fetchDramas() async {
    setState(() => isLoading = true);
    dramas = await DramaAPI.getHome(selectedCategory, 'id');
    setState(() => isLoading = false);
  }
  
  void _changeCategory(String categoryId) {
    setState(() {
      selectedCategory = categoryId;
      isLoading = true;
    });
    _fetchDramas();
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
              showSearch(context: context, delegate: DramaSearchDelegate());
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
              itemCount: availableApis.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  label: Text(availableApis[i]['name']!),
                  selected: selectedCategory == availableApis[i]['id'],
                  onSelected: (_) => _changeCategory(availableApis[i]['id']!),
                  backgroundColor: Colors.white10,
                  selectedColor: const Color(0xFF8B5CF6),
                  labelStyle: TextStyle(
                    color: selectedCategory == availableApis[i]['id'] ? Colors.white : Colors.grey
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
                      crossAxisCount: 3,
                      childAspectRatio: 0.65,
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
        // Navigator ke detail page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Detail: ${drama['title']}"))
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
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.grey),
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

// Search Delegate
class DramaSearchDelegate extends SearchDelegate {
  List<dynamic> searchResults = [];
  bool isLoading = false;
  String selectedCategory = 'freereels';
  
  final List<Map<String, String>> categories = [
    {'id': 'freereels', 'name': 'FreeReels'},
    {'id': 'melolo', 'name': 'Melolo'},
  ];
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("Cari drama favoritmu", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return _buildSearchResults();
  }
  
  Widget _buildSearchResults() {
    return Column(
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
                    searchResults = [];
                  });
                  _performSearch();
                },
                backgroundColor: Colors.white10,
                selectedColor: const Color(0xFF8B5CF6),
              ),
            ),
          ),
        ),
        // Results
        Expanded(
          child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : searchResults.isEmpty && query.isNotEmpty
              ? const Center(child: Text("Tidak ada hasil", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (c, i) => ListTile(
                    leading: const Icon(Icons.movie, color: Color(0xFF8B5CF6)),
                    title: Text(searchResults[i]['title'] ?? 'No Title', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${searchResults[i]['views'] ?? 0} views', style: const TextStyle(color: Colors.grey)),
                    onTap: () {
                      close(context, null);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Detail: ${searchResults[i]['title']}"))
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
  
  void _performSearch() async {
    if (query.isEmpty) return;
    setState(() => isLoading = true);
    searchResults = await DramaAPI.search(selectedCategory, query, 'id');
    setState(() => isLoading = false);
  }
  
  @override
  void updateQuery(String newQuery) {
    super.updateQuery(newQuery);
    if (newQuery.isNotEmpty) {
      _performSearch();
    }
  }
}
