class RuntimeMemoryStorage {
  static final Map<String, dynamic> _data = {};

  static T? get<T>(String key) => _data[key] as T?;

  static void set<T>(String key, T value) => _data[key] = value;

  static void remove(String key) => _data.remove(key);

  static void clear() {
    _data.clear();
    // Optionally, you can also clear the database or perform other cleanup tasks here.
  }


  static void setSession({ required String uId, required String username, required String accessToken, required String expiredAt}) {
    _data['session'] = {
      'uId': uId,
      'username': username,
      'accessToken': accessToken,
      'expiredAt': expiredAt
    };  
  }

} 