import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/drama_api.dart';
import 'video_player_page.dart';

class DetailPage extends StatefulWidget {
  final String dramaId;
  final String title;
  final String cover;
  final String platform;
  
  const DetailPage({
    super.key, 
    required this.dramaId,
    required this.title,
    required this.cover,
    required this.platform,
  });
  
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> detail = {};
  bool isLoading = true;
  bool isFavorite = false;
  int selectedEpisode = 1;
  
  @override
  void initState() {
    super.initState();
    _loadDetail();
    _checkFavorite();
  }
  
  Future<void> _loadDetail() async {
    setState(() => isLoading = true);
    detail = await DramaAPI.getDetail(widget.platform, widget.dramaId, 'id');
    setState(() => isLoading = false);
  }
  
  Future<void> _checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites != null) {
      setState(() {
        isFavorite = favorites.contains(widget.dramaId);
      });
    }
  }
  
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    
    if (isFavorite) {
      favorites.remove(widget.dramaId);
    } else {
      favorites.add(widget.dramaId);
    }
    
    await prefs.setStringList('favorites', favorites);
    setState(() => isFavorite = !isFavorite);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isFavorite ? "Ditambahkan ke favorit" : "Dihapus dari favorit"))
    );
  }
  
  void _playEpisode(int episodeIndex) {
    // Simpan ke riwayat
    _addToHistory(episodeIndex);
    
    // Buka video player
    Navigator.push(context, MaterialPageRoute(builder: (c) => VideoPlayerPage(
      platform: widget.platform,
      dramaId: widget.dramaId,
      chapterId: episodeIndex.toString(),
      lang: 'id',
      title: widget.title,
      episode: episodeIndex,
      totalEpisodes: detail['total_episodes'] ?? 0,
    )));
  }
  
  Future<void> _addToHistory(int episode) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    
    // Cek apakah sudah ada
    bool exists = false;
    for (int i = 0; i < history.length; i++) {
      if (history[i].startsWith(widget.dramaId)) {
        history[i] = '${widget.dramaId}|$episode|${DateTime.now().millisecondsSinceEpoch}';
        exists = true;
        break;
      }
    }
    
    if (!exists) {
      history.insert(0, '${widget.dramaId}|$episode|${DateTime.now().millisecondsSinceEpoch}');
    }
    
    // Batasi maksimal 50 riwayat
    if (history.length > 50) history.removeLast();
    
    await prefs.setStringList('history', history);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)))
          : CustomScrollView(
              slivers: [
                // App bar dengan tombol back & favorite
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.cover,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A1A1A)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
                
                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        
                        // Info bar
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                detail['total_episodes'] != null ? "${detail['total_episodes']} Ep" : "? Ep",
                                style: const TextStyle(fontSize: 12, color: Color(0xFF8B5CF6)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                detail['status'] ?? "Ongoing",
                                style: const TextStyle(fontSize: 12, color: Colors.green),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(Icons.visibility, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  detail['views']?.toString() ?? "0",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Sinopsis
                        const Text("SINOPSIS", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          detail['synopsis'] ?? "Tidak ada sinopsis",
                          style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        
                        // Daftar Episode
                        const Text("DAFTAR EPISODE", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        
                        _buildEpisodeList(),
                        
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildEpisodeList() {
    int totalEpisodes = detail['total_episodes'] ?? 0;
    if (totalEpisodes == 0) {
      return const Center(child: Text("Belum ada episode", style: TextStyle(color: Colors.grey)));
    }
    
    // Tampilkan 30 episode pertama dalam grid
    int showCount = totalEpisodes > 30 ? 30 : totalEpisodes;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: showCount,
      itemBuilder: (c, i) => ElevatedButton(
        onPressed: () => _playEpisode(i + 1),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          "${i + 1}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
