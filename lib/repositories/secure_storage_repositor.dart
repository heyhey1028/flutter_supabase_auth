import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin SecureStorageRepository {
  // Create storage
  static const storage = FlutterSecureStorage();

  static const String _keyAccessToken = 'access_token';

  static Future setAccessToken(String token) async {
    await storage.write(key: _keyAccessToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await storage.read(key: _keyAccessToken);
  }
}
