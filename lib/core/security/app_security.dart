import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AppSecurity {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: const IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Secure storage methods
  static Future<void> storeSecureToken(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecureToken(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> deleteSecureToken(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Hash sensitive data
  static String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Sanitize input
  static String sanitizeInput(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'[^\w\s@.-]'), ''); // Remove special chars except @ . -
  }

  // Generate secure random string
  static String generateSecureToken(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String token = '';
    for (int i = 0; i < length; i++) {
      token += chars[(random + i) % chars.length];
    }
    return token;
  }

  // Rate limiting (simple in-memory implementation)
  static final Map<String, List<int>> _rateLimitMap = {};
  
  static bool isRateLimited(String identifier, {int maxRequests = 5, int windowSeconds = 60}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final requests = _rateLimitMap[identifier] ?? [];
    
    // Remove old requests outside the window
    requests.removeWhere((timestamp) => now - timestamp > windowSeconds * 1000);
    
    if (requests.length >= maxRequests) {
      return true;
    }
    
    requests.add(now);
    _rateLimitMap[identifier] = requests;
    return false;
  }
}
