import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order_item.dart';

class OrderDatabaseHelper {
  static final OrderDatabaseHelper _instance = OrderDatabaseHelper._internal();
  factory OrderDatabaseHelper() => _instance;
  static Database? _database;

  OrderDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'order_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE orders(id TEXT PRIMARY KEY, watchName TEXT, imageUrl TEXT, totalPrice REAL, orderDate TEXT, quantity TEXT, status TEXT, estimatedDelivery TEXT)',
        );
      },
    );
  }

  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateOrder(Order order) async {
    final db = await database;
    await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final db = await database;
      final result = await db.update(
        'orders',
        {'status': newStatus},
        where: 'id = ?',
        whereArgs: [orderId],
      );
      debugPrint('Rows affected: $result'); // Debug print
    } catch (e) {
      debugPrint('Error updating status: $e'); // Debug print
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Order>> orders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orders');
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }
}