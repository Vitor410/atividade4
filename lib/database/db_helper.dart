import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/collection_model.dart';
import '../models/collection_item_model.dart';

class CollectionDBHelper {
  static Database? _database;
  static final CollectionDBHelper _instance = CollectionDBHelper._internal();

  CollectionDBHelper._internal();
  factory CollectionDBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath, "collections.db");

    return await openDatabase(path, version: 2, onCreate: _onCreateDB, onUpgrade: _onUpgradeDB);
  }

  Future<void> _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE collections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT,
        tipo_item TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE collection_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        collection_id INTEGER NOT NULL,
        nome TEXT NOT NULL,
        descricao TEXT,
        data_aquisicao TEXT NOT NULL,
        valor REAL NOT NULL,
        condicao TEXT NOT NULL,
        foto_path TEXT,
        detalhes_especificos TEXT NOT NULL,
        categoria TEXT NOT NULL,
        FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _onCreateDB(db, newVersion);
    }
  }

  Future<int> insertCollection(Collection collection) async {
    final db = await database;
    return await db.insert("collections", collection.toMap());
  }

  Future<List<Collection>> getCollections() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("collections");
    return maps.map((e) => Collection.fromMap(e)).toList();
  }

  Future<Collection?> getCollectionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "collections",
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Collection.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteCollection(int id) async {
    final db = await database;
    return await db.delete("collections", where: "id=?", whereArgs: [id]);
  }

  Future<int> insertCollectionItem(CollectionItem item) async {
    final db = await database;
    return await db.insert("collection_items", item.toMap());
  }

  Future<List<CollectionItem>> getItemsForCollection(int collectionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "collection_items",
      where: "collection_id = ?",
      whereArgs: [collectionId],
    );
    return maps.map((e) => CollectionItem.fromMap(e)).toList();
  }

  Future<int> deleteCollectionItem(int id) async {
    final db = await database;
    return await db.delete("collection_items", where: "id = ?", whereArgs: [id]);
  }
}
