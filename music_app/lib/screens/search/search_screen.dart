import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/song_provider.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/add_to_playlist_dialog.dart';
import '../../models/song_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _baseUrl = 'http://10.0.2.2:5102';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SongProvider>().fetchSongs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    context.read<SongProvider>().fetchSongs(search: value);
  }

  void _onGenreSelect(String genre) {
    context.read<SongProvider>().fetchSongs(genre: genre);
  }

  String _getAbsoluteUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty)
      return 'https://via.placeholder.com/60';
    if (relativeUrl.startsWith('http')) return relativeUrl;
    return '$_baseUrl${relativeUrl.startsWith('/') ? '' : '/'}$relativeUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Tìm kiếm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Bạn muốn nghe gì?',
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Consumer<SongProvider>(
                  builder: (context, songProvider, child) {
                    if (songProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_searchController.text.isEmpty) ...[
                            const Text(
                              'Khám phá các thể loại',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
                                _buildExploreCard(
                                  'Âm nhạc',
                                  Colors.pink,
                                  'Music',
                                ),
                                _buildExploreCard(
                                  'Podcasts',
                                  Colors.green[800]!,
                                  'Podcasts',
                                ),
                                _buildExploreCard(
                                  'Sự kiện trực tiếp',
                                  Colors.purple,
                                  'Events',
                                ),
                                _buildExploreCard(
                                  'Dành cho bạn',
                                  Colors.blue,
                                  'MadeForYou',
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Duyệt tìm tất cả',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
                                _buildGenreCard('Pop', Colors.orange, 'Pop'),
                                _buildGenreCard('V-Pop', Colors.red, 'V-Pop'),
                                _buildGenreCard('Indie', Colors.teal, 'Indie'),
                                _buildGenreCard('Rock', Colors.indigo, 'Rock'),
                              ],
                            ),
                          ],

                          if (songProvider.songs.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Gợi ý cho bạn'
                                  : 'Kết quả tìm kiếm',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: songProvider.songs.length,
                              itemBuilder: (context, index) {
                                final song = songProvider.songs[index];
                                return ListTile(
                                  onTap: () => context
                                      .read<AudioProvider>()
                                      .playSong(song),
                                  contentPadding: EdgeInsets.zero,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      _getAbsoluteUrl(song.coverImage),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.white10,
                                        child: const Icon(
                                          Icons.music_note,
                                          color: Colors.white24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    song.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    song.artistName,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddToPlaylistDialog(song: song),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreCard(String title, Color color, String genre) {
    return GestureDetector(
      onTap: () {
        _searchController.text = title;
        _onGenreSelect(genre);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(String title, Color color, String genre) {
    return GestureDetector(
      onTap: () {
        _searchController.text = title;
        _onGenreSelect(genre);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
