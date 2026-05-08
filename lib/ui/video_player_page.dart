import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/drama_api.dart';

class VideoPlayerPage extends StatefulWidget {
  final String platform;
  final String dramaId;
  final String chapterId;
  final String lang;
  final String title;
  final int episode;
  final int totalEpisodes;
  
  const VideoPlayerPage({
    super.key,
    required this.platform,
    required this.dramaId,
    required this.chapterId,
    required this.lang,
    required this.title,
    required this.episode,
    required this.totalEpisodes,
  });
  
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _controller;
  bool isLoading = true;
  bool isPlaying = false;
  String? videoUrl;
  Map<String, dynamic> videoData = {};
  
  @override
  void initState() {
    super.initState();
    _loadVideo();
  }
  
  Future<void> _loadVideo() async {
    setState(() => isLoading = true);
    videoData = await DramaAPI.getVideo(widget.platform, widget.dramaId, widget.chapterId, widget.lang);
    
    if (videoData.containsKey('streams') && videoData['streams'].isNotEmpty) {
      videoUrl = videoData['streams'][0]['url'];
      
      if (videoUrl != null && videoUrl!.isNotEmpty) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl!));
        await _controller!.initialize();
        await _controller!.play();
        setState(() {
          isPlaying = true;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }
  
  void _togglePlay() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        isPlaying = false;
      } else {
        _controller!.play();
        isPlaying = true;
      }
    });
  }
  
  void _nextEpisode() {
    if (widget.episode < widget.totalEpisodes) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => VideoPlayerPage(
        platform: widget.platform,
        dramaId: widget.dramaId,
        chapterId: (widget.episode + 1).toString(),
        lang: widget.lang,
        title: widget.title,
        episode: widget.episode + 1,
        totalEpisodes: widget.totalEpisodes,
      )));
    }
  }
  
  void _previousEpisode() {
    if (widget.episode > 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => VideoPlayerPage(
        platform: widget.platform,
        dramaId: widget.dramaId,
        chapterId: (widget.episode - 1).toString(),
        lang: widget.lang,
        title: widget.title,
        episode: widget.episode - 1,
        totalEpisodes: widget.totalEpisodes,
      )));
    }
  }
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "${widget.title} - Ep ${widget.episode} / ${widget.totalEpisodes}",
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)))
          : videoUrl == null
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text("Tidak dapat memutar video", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Video Player
                    AspectRatio(
                      aspectRatio: _controller?.value.aspectRatio ?? 16 / 9,
                      child: VideoPlayer(_controller!),
                    ),
                    
                    // Controls
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                            onPressed: widget.episode > 1 ? _previousEpisode : null,
                          ),
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              color: const Color(0xFF8B5CF6),
                              size: 48,
                            ),
                            onPressed: _togglePlay,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                            onPressed: widget.episode < widget.totalEpisodes ? _nextEpisode : null,
                          ),
                        ],
                      ),
                    ),
                    
                    // Info dan tombol favorit
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text("Gratis", style: TextStyle(fontSize: 12, color: Color(0xFF8B5CF6))),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text("Dubbing", style: TextStyle(fontSize: 12, color: Colors.orange)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
