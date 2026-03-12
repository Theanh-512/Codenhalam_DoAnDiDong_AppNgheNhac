import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isAuthenticated) {
        context.read<LibraryProvider>().fetchFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer2<AuthProvider, LibraryProvider>(
          builder: (context, auth, library, child) {
            return Column(
              children: [
                _buildHeader(context, auth),
                if (!auth.isAuthenticated)
                  _buildLoginPrompt(context)
                else
                  _buildLibraryContent(auth, library),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 15,
            child: Text(
              auth.user?.username.substring(0, 1).toUpperCase() ?? '?',
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Thư viện',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.search, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          const Icon(Icons.add, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.library_music_outlined,
                size: 64,
                color: Colors.white24,
              ),
              const SizedBox(height: 16),
              const Text(
                'Thư viện của bạn ở đây',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Đăng nhập để xem danh sách phát, nghệ sĩ và album đã lưu.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/login');
                  _fetchData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryContent(AuthProvider auth, LibraryProvider library) {
    return Expanded(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Danh sách phát'),
                _buildFilterChip('Nghệ sĩ'),
                _buildFilterChip('Album'),
              ],
            ),
          ),
          Expanded(
            child: library.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildLibraryItem(
                        'Bài hát ưa thích',
                        'Danh sách phát • ${library.favoriteSongs.length} bài hát',
                        '',
                        isLiked: true,
                      ),
                      if (library.favoriteSongs.isNotEmpty)
                        ...library.favoriteSongs.map(
                          (song) => _buildLibraryItem(
                            song.title,
                            'Bài hát • ${song.artistName}',
                            song.coverImage ?? '',
                          ),
                        ),
                      _buildLibraryItem(
                        'Playlist của ${auth.user?.username}',
                        'Danh sách phát • ${auth.user?.username}',
                        'https://via.placeholder.com/150',
                      ),
                      const SizedBox(height: 16),
                      _buildAddItem(Icons.add, 'Thêm nghệ sĩ'),
                      _buildAddItem(Icons.add, 'Thêm podcast'),
                      const SizedBox(height: 100),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey[900],
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildLibraryItem(
    String title,
    String subtitle,
    String imageUrl, {
    bool isLiked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: isLiked
                  ? const LinearGradient(
                      colors: [Colors.deepPurple, Colors.blueAccent],
                    )
                  : null,
              color: imageUrl.isEmpty ? Colors.grey[800] : null,
            ),
            child: isLiked
                ? const Icon(Icons.favorite, color: Colors.white, size: 30)
                : (imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.music_note, color: Colors.white24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white54, size: 32),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
