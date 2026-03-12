import 'package:flutter/material.dart';
import '../../models/song_model.dart';
import '../../core/services/api_service.dart';
import '../../providers/audio_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/add_to_playlist_dialog.dart';

class SongListScreen extends StatefulWidget {
  final String title;
  final String? genre;
  final String? search;

  const SongListScreen({
    super.key,
    required this.title,
    this.genre,
    this.search,
  });

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  final ApiService _apiService = ApiService();
  List<SongModel> _songs = [];
  bool _isLoading = true;
  final String _baseUrl = 'http://10.0.2.2:5102';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      final queryParams = <String, dynamic>{};
      if (widget.search != null) queryParams['search'] = widget.search;
      if (widget.genre != null) queryParams['genre'] = widget.genre;

      final response = await _apiService.dio.get(
        '/songs',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _songs = data.map((json) => SongModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading songs for list: $e');
      setState(() => _isLoading = false);
    }
  }

  String _getAbsoluteUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    if (relativeUrl.startsWith('http')) return relativeUrl;
    return '$_baseUrl${relativeUrl.startsWith('/') ? '' : '/'}$relativeUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _songs.isEmpty
          ? const Center(
              child: Text(
                'Không tìm thấy bài hát nào',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                return ListTile(
                  onTap: () {
                    context.read<AudioProvider>().playSong(song);
                  },
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      _getAbsoluteUrl(song.coverImage),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
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
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white70),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddToPlaylistDialog(song: song),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
