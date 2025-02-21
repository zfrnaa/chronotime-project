import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/watch_item.dart';

class WatchDatabaseHelper {
  static final WatchDatabaseHelper _instance = WatchDatabaseHelper._internal();
  factory WatchDatabaseHelper() => _instance;
  static Database? _database;

  WatchDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'watch_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE watch_items(id TEXT PRIMARY KEY, name TEXT, imageUrl TEXT, price REAL, description TEXT, features TEXT, warrantyYears INTEGER)',
        );
      },
    );
  }

  //insert watchitem
  Future<void> insertWatchItem(WatchItem watchItem) async {
    final db = await database;
    await db.insert(
      'watch_items',
      watchItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //edit watchitem
  Future<void> updateWatchItem(WatchItem watchItem) async {
    final db = await database;
    await db.update(
      'watch_items',
      watchItem.toMap(),
      where: 'id = ?',
      whereArgs: [watchItem.id],
    );
  }

  //delete watchitem
  Future<void> deleteWatchItem(String id) async {
    final db = await database;
    await db.delete(
      'watch_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<WatchItem>> watchItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('watch_items');
    return List.generate(maps.length, (i) {
      return WatchItem.fromMap(maps[i]);
    });
  }
}