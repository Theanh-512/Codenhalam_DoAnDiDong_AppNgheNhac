import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../services/firebase/firebase_storage_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/song_provider.dart';
import '../../core/services/api_service.dart';

class UploadFormScreen extends StatefulWidget {
  const UploadFormScreen({super.key});

  @override
  State<UploadFormScreen> createState() => _UploadFormScreenState();
}

class _UploadFormScreenState extends State<UploadFormScreen> {
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  File? _musicFile;
  File? _coverImage;
  bool _isUploading = false;
  final _firebaseService = FirebaseStorageService();

  Future<void> _pickMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      setState(() => _musicFile = File(result.files.single.path!));
    }
  }

  Future<void> _pickCover() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() => _coverImage = File(result.files.single.path!));
    }
  }

  Future<void> _handleSubmit() async {
    if (_musicFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên và chọn file nhạc!')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. Upload to Firebase Storage
      String? musicUrl = await _firebaseService.uploadFile(
        _musicFile!,
        'songs',
      );
      String? coverUrl;
      if (_coverImage != null) {
        coverUrl = await _firebaseService.uploadFile(_coverImage!, 'covers');
      }

      if (musicUrl == null) throw Exception('Upload nhạc thất bại');

      // 2. Save metadata to ASP.NET Core Backend
      final apiService = ApiService();
      final success = await apiService.uploadExternalSong(
        title: _titleController.text,
        genre: _genreController.text.isEmpty
            ? 'General'
            : _genreController.text,
        musicUrl: musicUrl,
        coverUrl: coverUrl,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tải lên thành công!')));
          Navigator.pop(context);
          context.read<SongProvider>().fetchSongs(); // Refresh list
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tải lên âm nhạc'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Cover Image Preview/Picker
            GestureDetector(
              onTap: _pickCover,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  image: _coverImage != null
                      ? DecorationImage(
                          image: FileImage(_coverImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _coverImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            color: Colors.white54,
                            size: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ảnh bìa',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Tên bài hát', Icons.title),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _genreController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Thể loại (VD: Pop, V-Pop)',
                Icons.category,
              ),
            ),
            const SizedBox(height: 24),
            // Music File Picker
            InkWell(
              onTap: _pickMusic,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.audio_file, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _musicFile == null
                            ? 'Chọn file âm nhạc (.mp3)'
                            : _musicFile!.path.split('/').last,
                        style: TextStyle(
                          color: _musicFile == null
                              ? Colors.white54
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'XÁC NHẬN TẢI LÊN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
