import 'package:flutter/material.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bắt đầu tạo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _buildCreateOption(
                Icons.music_note,
                'Danh sách phát',
                'Tạo danh sách phát gồm các bài hát hoặc tập podcast',
              ),
              _buildCreateOption(
                Icons.people_outline,
                'Danh sách phát cộng tác',
                'Cùng bạn bè tạo danh sách phát',
              ),
              _buildCreateOption(
                Icons.animation,
                'Giai điệu chung',
                'Tạo danh sách phát tổng hợp gu nhạc của bạn bè',
              ),
              const Divider(color: Colors.white24, height: 40),
              _buildCreateOption(
                Icons.cloud_upload_outlined,
                'Tải lên bài hát',
                'Bạn là nghệ sĩ? Hãy chia sẻ âm nhạc của bạn với mọi người (Yêu cầu đăng nhập)',
                isArtistAction: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateOption(
    IconData icon,
    String title,
    String subtitle, {
    bool isArtistAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
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
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
