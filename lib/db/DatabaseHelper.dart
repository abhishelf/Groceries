import 'package:grocery/modal/Cart.dart';
import 'package:grocery/modal/Wishlist.dart';
import 'package:grocery/util/String.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + DB_NAME;

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $TABLE_CART($COL_ID TEXT PRIMARY KEY, $COL_IMAGE TEXT, $COl_TITLE TEXT, $COL_PRICE TEXT, $COL_QUANT TEXT, $COL_CART_Q TEXT)');

    await db.execute(
        'CREATE TABLE $TABLE_WISHLIST($COL_ID TEXT PRIMARY KEY, $COL_IMAGE TEXT, $COl_TITLE TEXT, $COL_PRICE TEXT, $COL_QUANT TEXT)');
  }

  // CART TABLE OPERATION
  Future<int> insertCartItem(Cart cart) async {
    Database db = await this.database;
    var result = await db.insert(TABLE_CART, cart.toMap());
    return result;
  }

  Future<int> updateCartItem(Cart cart) async {
    Database db = await this.database;
    var result = await db.update(TABLE_CART, cart.toMap(),
        where: '$COL_ID = ?', whereArgs: [cart.id]);
    return result;
  }

  Future<int> deleteCartItem(String id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $TABLE_CART where $COL_ID = $id');
    return result;
  }

  Future<int> deleteCart() async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $TABLE_CART');
    return result;
  }

  Future<int> deleteWishlist() async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $TABLE_WISHLIST');
    return result;
  }

  Future<List<Map<String, dynamic>>> getCartMapList() async {
    Database db = await this.database;
    var result =
        await db.rawQuery('Select * from $TABLE_CART order by $COL_CART_Q ASC');
    return result;
  }

  Future<List<Cart>> getCartList() async {
    var cartMapList = await getCartMapList();

    List<Cart> cartList = List<Cart>();
    for (int i = 0; i < cartMapList.length; i++) {
      cartList.add(Cart.fromMap(cartMapList[i]));
    }
    return cartList;
  }

  Future<List<Map<String, dynamic>>> getCartMapById(String id) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('Select * from $TABLE_CART Where $COL_ID = $id');
    return result;
  }

  Future<Cart> getCartById(String id) async {
    var cart = await getCartMapById(id);

    List<Cart> cartList = List<Cart>();
    for (int i = 0; i < cart.length; i++) {
      cartList.add(Cart.fromMap(cart[i]));
    }

    if (cart.length == 0) return null;
    return cartList[0];
  }

  // Wishlist Table Operation
  Future<int> addToWishlist(Wishlist wishlist) async {
    Database db = await this.database;
    var result = await db.insert(TABLE_WISHLIST, wishlist.toMap());
    return result;
  }

  Future<int> removeFromWishlist(String id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $TABLE_WISHLIST where $COL_ID = $id');
    return result;
  }

  Future<bool> getWishlistById(String id) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('Select * from $TABLE_WISHLIST Where $COL_ID = $id');
    try {
      if (result.length > 0) return true;
    } catch (error) {}
    return false;
  }

  Future<List<Wishlist>> getWishlist() async {
    Database db = await this.database;
    var result = await db.rawQuery('Select * from $TABLE_WISHLIST');

    List<Wishlist> wishlist = List<Wishlist>();
    for (int i = 0; i < result.length; i++) {
      wishlist.add(Wishlist.fromMap(result[i]));
    }

    return wishlist;
  }
}
