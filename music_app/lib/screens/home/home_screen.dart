import 'package:flutter/material.dart';
import '../song_list/song_list_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/song_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/audio_provider.dart';
import '../../models/song_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _baseUrl = 'http://10.0.2.2:5102';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SongProvider>().fetchSongs();
    });
  }

  String _getAbsoluteUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty)
      return 'https://via.placeholder.com/150';
    if (relativeUrl.startsWith('http')) return relativeUrl;
    return '$_baseUrl${relativeUrl.startsWith('/') ? '' : '/'}$relativeUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) => GestureDetector(
                        onTap: () {
                          // In a real app, this might open account settings or switch tab
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 15,
                          child: Text(
                            auth.isAuthenticated
                                ? auth.user!.username
                                      .substring(0, 1)
                                      .toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildChip('Tất cả', isSelected: true),
                    _buildChip('Âm nhạc'),
                    _buildChip('Podcasts'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Recent Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<SongProvider>(
                  builder: (context, songProvider, child) {
                    if (songProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }
                    if (songProvider.songs.isEmpty) {
                      return const Text(
                        'Chưa có bài hát nào',
                        style: TextStyle(color: Colors.white70),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: (songProvider.songs.length > 6)
                          ? 6
                          : songProvider.songs.length,
                      itemBuilder: (context, index) {
                        return _buildRecentItem(songProvider.songs[index]);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Nội dung bạn hay nghe gần đây',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Consumer<SongProvider>(
                  builder: (context, songProvider, child) {
                    if (songProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      itemCount: songProvider.songs.length,
                      itemBuilder: (context, index) {
                        return _buildListSong(songProvider.songs[index]);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Bảng xếp hạng hàng đầu của bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    _buildChartItem(
                      context,
                      'Top 50 - Việt Nam',
                      Colors.pink,
                      Colors.purple,
                      genre: 'V-Pop',
                    ),
                    _buildChartItem(
                      context,
                      'Top 50 - Toàn cầu',
                      Colors.blue,
                      Colors.green,
                      genre: 'Pop',
                    ),
                    _buildChartItem(
                      context,
                      'Video âm nhạc hàng đầu',
                      Colors.orange,
                      Colors.red,
                      genre: 'EDM',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.green : Colors.grey[900],
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 12,
        ),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildRecentItem(SongModel song) {
    return GestureDetector(
      onTap: () => context.read<AudioProvider>().playSong(song),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: Image.network(
                _getAbsoluteUrl(song.coverImage),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: Colors.white10,
                  child: const Icon(Icons.music_note, color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                song.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSong(SongModel song) {
    return GestureDetector(
      onTap: () => context.read<AudioProvider>().playSong(song),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _getAbsoluteUrl(song.coverImage),
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 140,
                  height: 140,
                  color: Colors.white10,
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white24,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              song.artistName,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartItem(
    BuildContext context,
    String title,
    Color color1,
    Color color2, {
    String? genre,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongListScreen(title: title, genre: genre),
          ),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.trending_up, color: Colors.white, size: 24),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
