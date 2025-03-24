import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  static const String _sessionKey = "SESSION_ID";

  /// Tạo hoặc lấy Session ID từ local storage
  static Future<String> getOrCreateSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(_sessionKey);

    if (sessionId == null) {
      sessionId = const Uuid().v4(); // Tạo UUID v4
      await prefs.setString(_sessionKey, sessionId);
    }

    return sessionId;
  }

  static Future<String> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey) ?? "";
  }

  /// Xóa Session ID (nếu cần)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
