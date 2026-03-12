import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../core/services/api_service.dart';

class LibraryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<SongModel> _favoriteSongs = [];
  bool _isLoading = false;

  List<SongModel> get favoriteSongs => _favoriteSongs;
  bool get isLoading => _isLoading;

  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.dio.get('/favorites');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _favoriteSongs = data.map((json) => SongModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      _favoriteSongs = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleFavorite(SongModel song) async {
    try {
      if (song.isFavorite) {
        await _apiService.dio.delete('/favorites/${song.id}');
        song.isFavorite = false;
        _favoriteSongs.removeWhere((s) => s.id == song.id);
      } else {
        await _apiService.dio.post('/favorites/${song.id}');
        song.isFavorite = true;
        _favoriteSongs.add(song);
      }
      notifyListeners();
      return true;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }
}
