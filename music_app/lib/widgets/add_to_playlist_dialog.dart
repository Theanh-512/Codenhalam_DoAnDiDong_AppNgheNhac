import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/playlist_provider.dart';
import '../../models/song_model.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final SongModel song;

  const AddToPlaylistDialog({super.key, required this.song});

  @override
  State<AddToPlaylistDialog> createState() => _AddToPlaylistDialogState();
}

class _AddToPlaylistDialogState extends State<AddToPlaylistDialog> {
  @override
  void initState() {
    super.initState();
    context.read<PlaylistProvider>().fetchPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Thêm vào danh sách phát',
        style: TextStyle(color: Colors.white),
      ),
      content: Consumer<PlaylistProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }

          return SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.green),
                  title: const Text(
                    'Tạo danh sách phát mới',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => _showCreatePlaylistDialog(context),
                ),
                const Divider(color: Colors.white24),
                if (provider.playlists.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Bạn chưa có danh sách phát nào',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = provider.playlists[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.playlist_play,
                            color: Colors.white70,
                          ),
                          title: Text(
                            playlist.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () async {
                            final success = await provider.addSongToPlaylist(
                              playlist.id,
                              widget.song.id,
                            );
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Đã thêm vào ${playlist.name}'
                                        : 'Lỗi khi thêm bài hát',
                                  ),
                                  backgroundColor: success
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Tên danh sách phát mới',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nhập tên...',
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await context.read<PlaylistProvider>().createPlaylist(
                  controller.text,
                );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Tạo', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
