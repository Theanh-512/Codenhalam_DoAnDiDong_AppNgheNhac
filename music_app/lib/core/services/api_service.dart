import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // Change this to your server IP if testing on a physical device
      // 10.0.2.2 is the localhost for Android Emulator
      baseUrl: 'http://10.0.2.2:5102/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  final _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _storage.read(key: 'jwt');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // Allow self-signed certificates for local development (if using https)
    // Note: In production, use proper certificates
  }

  Dio get dio => _dio;

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<bool> uploadExternalSong({
    required String title,
    required String genre,
    required String musicUrl,
    String? coverUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/songs/upload-external',
        data: {
          'title': title,
          'genre': genre,
          'fileUrl': musicUrl,
          'coverImageUrl': coverUrl,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error uploading external song metadata: $e');
      return false;
    }
  }
}
