import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static const String _hiveKey = 'hive_encryption_key';

  Future<void> saveHiveKey(String key) async {
    await _storage.write(key: _hiveKey, value: key);
  }

  Future<String?> getHiveKey() async {
    return await _storage.read(key: _hiveKey);
  }
}
