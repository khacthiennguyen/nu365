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
    print("DEBUG: Getting database instance");
    if (_database == null) {
      print("DEBUG: Database not initialized, setting up now");
      return await setupDatabase();
    }
    print("DEBUG: Returning existing database instance");
    return _database!;
  }

  /// Initialize and set up the database
  static Future<Database> setupDatabase() async {
    // Nếu database đã được khởi tạo, trả về instance hiện tại
    if (_database != null) {
      print("DEBUG: Database already initialized, returning existing instance");
      return _database!;
    }

    final String path = join(await getDatabasesPath(), _file);
    print("DEBUG: Setting up database at path: $path");

    try {
      final Database database = await openDatabase(
        path,
        version: 2, // Tăng phiên bản từ 1 lên 2
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

      print("DEBUG: Database opened successfully");
      _database = database;
      return database;
    } catch (e) {
      print("DEBUG: Error initializing database: $e");
      rethrow; // Re-throw để caller biết đã có lỗi
    }
  }

  /// Create database tables on first initialization
  static Future<void> _onCreate(Database database, int version) async {
    print("DEBUG: Creating database tables for the first time");
    const List<String> scripts = [
      "CREATE TABLE IF NOT EXISTS Session (id INTEGER PRIMARY KEY, uId TEXT, username TEXT, accessToken TEXT, expiredAt TEXT)"
    ];

    for (final script in scripts) {
      print("DEBUG: Executing SQL: $script");
      await database.execute(script);
    }
    print("DEBUG: Database tables created successfully");
  }

  /// Handle database version upgrades
  static Future<void> _onUpgrade(
      Database database, int oldVersion, int newVersion) async {
    print("DEBUG: Upgrading database from version $oldVersion to $newVersion");
    if (oldVersion < 2) {
      print("DEBUG: Adding email column to Session table");
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
    print("DEBUG: Saving session to SQLite");
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
    print("DEBUG: Session saved successfully to SQLite");
  }

  static Future<void> deleteSession() async {
    print("DEBUG: Deleting session from SQLite");
    final db = await getDatabase();
    await db.delete("Session");
    print("DEBUG: Session deleted successfully from SQLite");
  }
}
