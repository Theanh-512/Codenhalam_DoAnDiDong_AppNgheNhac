import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/song_provider.dart';
import '../../models/song_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedGenre;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _selectedGenre = null;
    });
    context.read<SongProvider>().fetchSongs(search: query);
  }

  void _onGenreSelect(String genre) {
    setState(() {
      _selectedGenre = genre;
      _isSearching = false;
      _searchController.clear();
    });
    context.read<SongProvider>().fetchSongs(genre: genre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (_selectedGenre != null || _isSearching)
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedGenre = null;
                                  _isSearching = false;
                                  _searchController.clear();
                                });
                                context.read<SongProvider>().fetchSongs();
                              },
                            ),
                          const Text(
                            'Tìm kiếm',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                      hintText: 'Bạn muốn nghe gì?',
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<SongProvider>(
                builder: (context, songProvider, child) {
                  if (_isSearching || _selectedGenre != null) {
                    return _buildSearchResults(songProvider);
                  }
                  return _buildBrowseView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(SongProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }
    if (provider.songs.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy kết quả nào',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.songs.length,
      itemBuilder: (context, index) {
        final song = provider.songs[index];
        return _buildSongTile(song);
      },
    );
  }

  Widget _buildBrowseView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khám phá nội dung mới mẻ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildExploreCard('#v-pop', 'V-Pop', Colors.pink),
              _buildExploreCard('#pop', 'Pop', Colors.blue),
              _buildExploreCard('#indie', 'Indie', Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Duyệt tìm tất cả',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildGenreCard(
                'Âm nhạc',
                'Music',
                Colors.pink,
                'https://via.placeholder.com/100',
              ),
              _buildGenreCard(
                'Podcasts',
                'Podcasts',
                Colors.teal,
                'https://via.placeholder.com/101',
              ),
              _buildGenreCard(
                'V-Pop',
                'V-Pop',
                Colors.orange,
                'https://via.placeholder.com/102',
              ),
              _buildGenreCard(
                'Pop',
                'Pop',
                Colors.blue,
                'https://via.placeholder.com/103',
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSongTile(SongModel song) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          song.coverImage ?? 'https://via.placeholder.com/150',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[800],
            child: const Icon(Icons.music_note),
          ),
        ),
      ),
      title: Text(song.title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        '${song.artistName} • ${song.genre}',
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: const Icon(Icons.more_horiz, color: Colors.white70),
    );
  }

  Widget _buildExploreCard(String label, String genre, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onGenreSelect(genre),
        child: Container(
          height: 140,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(
    String title,
    String genre,
    Color color,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () => _onGenreSelect(genre),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -5,
              child: Transform.rotate(
                angle: 0.5,
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
