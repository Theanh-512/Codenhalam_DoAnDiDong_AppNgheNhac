import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 15,
                    child: Text(
                      'T',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildChip('Tất cả', isSelected: true),
                  _buildChip('Âm nhạc'),
                  _buildChip('Podcasts'),
                ],
              ),
              const SizedBox(height: 20),

              // Recent Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildRecentItem(
                    'tiếng ồn trắng - học bài.',
                    'https://via.placeholder.com/150',
                  ),
                  _buildRecentItem(
                    'Thiên Hạ Nghe Gì',
                    'https://via.placeholder.com/151',
                  ),
                  _buildRecentItem('marzuz', 'https://via.placeholder.com/152'),
                  _buildRecentItem(
                    'Tuyển Tập Nhạc Tết Bùi Công Na...',
                    'https://via.placeholder.com/153',
                  ),
                  _buildRecentItem(
                    'Indie Việt Nam 2025',
                    'https://via.placeholder.com/154',
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Text(
                'Nội dung bạn hay nghe gần đây',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildListSong(
                'Ước Gì',
                'Mỹ Tâm',
                'https://via.placeholder.com/160',
              ),
              _buildListSong(
                'Thanh Tân',
                'VƯƠNG BÌNH',
                'https://via.placeholder.com/161',
              ),
              _buildListSong(
                'Chờ Ngày Mưa Tan Cover - Rock V...',
                'Truong Nguyen',
                'https://via.placeholder.com/162',
              ),

              const SizedBox(height: 32),
              const Text(
                'Bảng xếp hạng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChartItem('Top 50', 'VIETNAM', Colors.deepOrange),
                    _buildChartItem('HOT HITS', 'VIETNAM', Colors.pink),
                    _buildChartItem('Global', 'TOP 50', Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for MiniPlayer
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

  Widget _buildRecentItem(String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            child: Image.network(
              imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSong(String title, String artist, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_horiz, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildChartItem(String title, String sub, Color color) {
    return Container(
      width: 150,
      height: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.music_note, color: Colors.white24, size: 24),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(sub, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
