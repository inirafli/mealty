import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/model/cart.dart';

class CartDatabaseHelper {
  static final CartDatabaseHelper _instance = CartDatabaseHelper._internal();

  factory CartDatabaseHelper() {
    return _instance;
  }

  CartDatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE cart(id TEXT PRIMARY KEY, name TEXT, price INTEGER, image TEXT, quantity INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertCartItem(CartItem item) async {
    final db = await database;
    await db.insert('cart', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');

    return List.generate(maps.length, (i) {
      return CartItem.fromMap(maps[i]);
    });
  }

  Future<void> updateCartItem(CartItem item) async {
    final db = await database;
    await db.update(
      'cart',
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id],
    );
  }

  Future<void> deleteCartItem(String id) async {
    final db = await database;
    await db.delete(
      'cart',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}