import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.data['isSuccess']) {
        _user = UserModel.fromJson(response.data);
        await _apiService.saveToken(_user!.token);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String role = 'User',
    String? artistName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.dio.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'fullName': fullName,
          'role': role,
          'artistName': artistName,
        },
      );

      if (response.data['isSuccess']) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _apiService.deleteToken();
    _user = null;
    notifyListeners();
  }
}
