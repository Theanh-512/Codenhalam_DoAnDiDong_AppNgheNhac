import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../core/services/api_service.dart';

class SongProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<SongModel> _songs = [];
  bool _isLoading = false;

  List<SongModel> get songs => _songs;
  bool get isLoading => _isLoading;

  Future<void> fetchSongs({String? search, String? genre}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (genre != null && genre.isNotEmpty) queryParams['genre'] = genre;

      final response = await _apiService.dio.get(
        '/songs',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _songs = data.map((json) => SongModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
