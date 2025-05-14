import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite database handler for local storage
class SQLite {
  static final String _file = 'database.db';
  static Database? _database;

  /// Check if database is initialized
  static bool get isInitialized => _database != null;

  /// Get the database instance
  static Database get database {
    if (_database == null) {
      throw Exception("Database not initialized. Call setupDatabase() first.");
    }
    return _database!;
  }

  /// Safe access to database with auto-initialization if needed
  static Future<Database> getDatabase() async {
    if (_database == null) {
      return await setupDatabase();
    }
    return _database!;
  }

  /// Initialize and set up the database
  static Future<Database> setupDatabase() async {
    // Nếu database đã được khởi tạo, trả về instance hiện tại
    if (_database != null) {
      return _database!;
    }

    final String path = join(await getDatabasesPath(), _file);

    try {
      final Database database = await openDatabase(
        path,
        version: 2, // Tăng phiên bản từ 1 lên 2
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

      _database = database;
      return database;
    } catch (e) {
      // print("Error initializing database: $e");
      rethrow; // Re-throw để caller biết đã có lỗi
    }
  }

  /// Create database tables on first initialization
  static Future<void> _onCreate(Database database, int version) async {
    const List<String> scripts = [
      "CREATE TABLE IF NOT EXISTS Session (id INTEGER PRIMARY KEY, uId TEXT, username TEXT, email TEXT, accessToken TEXT, expiredAt TEXT)"
    ];

    for (final script in scripts) {
      await database.execute(script);
    }
  }

  /// Handle database version upgrades
  static Future<void> _onUpgrade(
      Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Thêm cột email vào bảng Session hiện có
      await database.execute("ALTER TABLE Session ADD COLUMN email TEXT");
    }
  }

  static Future<void> saveSession({
    required String uId,
    required String username,
    required String email,
    required String accessToken,
    required String expiredAt,
  }) async {
    final db =
        await getDatabase(); // Sử dụng getDatabase thay vì database trực tiếp

    await db.insert(
      "Session",
      {
        "id": 1, // Using fixed ID 1 to always update the same record
        "uId": uId,
        "username": username,
        "email": email,
        "accessToken": accessToken,
        "expiredAt": expiredAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteSession() async {
    final db = await getDatabase();
    db.delete("Session");
  }
}
