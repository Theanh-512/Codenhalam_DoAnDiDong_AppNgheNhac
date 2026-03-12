import 'package:flutter/material.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../core/services/api_service.dart';

class PlaylistProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<PlaylistModel> _playlists = [];
  bool _isLoading = false;

  List<PlaylistModel> get playlists => _playlists;
  bool get isLoading => _isLoading;

  Future<void> fetchPlaylists() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.dio.get('/playlists');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _playlists = data.map((json) => PlaylistModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching playlists: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createPlaylist(String name) async {
    try {
      final response = await _apiService.dio.post(
        '/playlists',
        data: {'name': name},
      );
      if (response.statusCode == 200) {
        await fetchPlaylists();
        return true;
      }
    } catch (e) {
      print('Error creating playlist: $e');
    }
    return false;
  }

  Future<void> deletePlaylist(int id) async {
    try {
      final response = await _apiService.dio.delete('/playlists/$id');
      if (response.statusCode == 200) {
        _playlists.removeWhere((p) => p.id == id);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting playlist: $e');
    }
  }

  Future<List<SongModel>> getPlaylistSongs(int playlistId) async {
    try {
      final response = await _apiService.dio.get(
        '/playlists/$playlistId/songs',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SongModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching playlist songs: $e');
    }
    return [];
  }

  Future<bool> addSongToPlaylist(int playlistId, int songId) async {
    try {
      final response = await _apiService.dio.post(
        '/playlists/$playlistId/songs',
        data: {'songId': songId},
      );
      if (response.statusCode == 200) {
        await fetchPlaylists(); // Refresh counts
        return true;
      }
    } catch (e) {
      print('Error adding song to playlist: $e');
    }
    return false;
  }

  Future<bool> removeSongFromPlaylist(int playlistId, int songId) async {
    try {
      final response = await _apiService.dio.delete(
        '/playlists/$playlistId/songs/$songId',
      );
      if (response.statusCode == 200) {
        await fetchPlaylists(); // Refresh counts
        return true;
      }
    } catch (e) {
      print('Error removing song from playlist: $e');
    }
    return false;
  }
}
