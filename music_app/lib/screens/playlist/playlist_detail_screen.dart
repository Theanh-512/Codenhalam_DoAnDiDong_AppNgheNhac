import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/playlist_model.dart';
import '../../models/song_model.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/audio_provider.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<SongModel> _songs = [];
  bool _isLoading = true;
  final String _baseUrl = 'https://10.0.2.2:7240';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await context.read<PlaylistProvider>().getPlaylistSongs(
      widget.playlist.id,
    );
    if (mounted) {
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
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
        title: Text(widget.playlist.name),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _songs.isEmpty
          ? const Center(
              child: Text(
                'Chưa có bài hát nào trong playlist này',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                return ListTile(
                  onTap: () {
                    context.read<AudioProvider>().playSong(song);
                  },
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
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async {
                      final success = await context
                          .read<PlaylistProvider>()
                          .removeSongFromPlaylist(widget.playlist.id, song.id);
                      if (success) _loadSongs();
                    },
                  ),
                );
              },
            ),
    );
  }
}
