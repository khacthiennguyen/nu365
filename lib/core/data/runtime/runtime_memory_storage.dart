class RuntimeMemoryStorage {
  static final Map<String, dynamic> _data = {};

  static T? get<T>(String key) => _data[key] as T?;

  static void set<T>(String key, T value) => _data[key] = value;

  static void remove(String key) => _data.remove(key);

  static void clear() {
    print("DEBUG: Clearing RuntimeMemoryStorage");
    _data.clear();
    // Optionally, you can also clear the database or perform other cleanup tasks here.
  }

  static void setSession(
      {required String uId,
      required String username,
      required String email,
      required String accessToken,
      required String expiredAt}) {
    print("DEBUG: Setting session in RuntimeMemoryStorage");
    _data['session'] = {
      'uId': uId,
      'username': username,
      'email': email,
      'accessToken': accessToken,
      'expiredAt': expiredAt
    };
  }

  static bool hasSession() {
    return _data.containsKey('session');
  }

  static Map<String, dynamic>? getSession() {
    return _data['session'] as Map<String, dynamic>?;
  }
}
