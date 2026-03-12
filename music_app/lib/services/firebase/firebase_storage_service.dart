import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload file lên Firebase Storage và trả về link URL trực tiếp
  /// [file]: Tệp tin cần upload (Music hoặc Image)
  /// [folder]: Thư mục trên Firebase ('songs' hoặc 'covers')
  Future<String?> uploadFile(File file, String folder) async {
    try {
      // 1. Tạo tên file duy nhất dựa trên thời gian
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';

      // 2. Tham chiếu đến vị trí lưu trữ
      Reference ref = _storage.ref().child('$folder/$fileName');

      // 3. Thực hiện Upload
      UploadTask uploadTask = ref.putFile(file);

      // 4. Chờ hoàn tất và lấy URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Lỗi Firebase Storage: $e');
      return null;
    }
  }

  /// Xóa file trên Firebase khi không cần thiết
  Future<void> deleteFile(String fileUrl) async {
    try {
      Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      print('Lỗi xóa file Firebase: $e');
    }
  }
}
