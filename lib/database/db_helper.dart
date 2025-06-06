import 'dart:async';

import 'package:path/path.dart';
import 'package:sa_petshop/models/consulta_model.dart';
import 'package:sa_petshop/models/pet_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_petshop/models/collection_model.dart';
import 'package:sa_petshop/models/collection_item_model.dart';

class PetShopDBHelper {
  static Database? _database; //obj para criar conexões
  //transformando a classe em singleton ->
  //não permite instanciar outro objeto enquanto um objeto estiver ativo
  static final PetShopDBHelper _instance = PetShopDBHelper._internal();

  //construtor do Singleton
  PetShopDBHelper._internal();
  factory PetShopDBHelper() {
    return _instance; 
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!; //se o banco já existe , retorna ele mesmo
    }
    //se não existe - inicia a conexão
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath, "petshop.db"); //caminho do banco de Dados

    return await openDatabase(path, version: 2, onCreate: _onCreateDB, onUpgrade: _onUpgradeDB);
  }

  Future<void> _onCreateDB(Database db, int version) async {
    // Cria a tabela 'pets'
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        raca TEXT NOT NULL,
        nome_dono TEXT NOT NULL,
        telefone_dono TEXT NOT NULL
      )
    ''');
    print("banco pets criado");

    // Cria a tabela 'consultas'
    await db.execute('''
      CREATE TABLE IF NOT EXISTS consultas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        data_hora TEXT NOT NULL, 
        tipo_servico TEXT NOT NULL,
        observacao TEXT NOT NULL,
        FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
      )
    ''');
    print("banco consultas criado");

    // Cria a tabela 'collections'
    await db.execute('''
      CREATE TABLE IF NOT EXISTS collections(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        tipo_item TEXT NOT NULL
      )
    ''');

    // Cria a tabela 'collection_items'
    await db.execute('''
      CREATE TABLE IF NOT EXISTS collection_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        collection_id INTEGER NOT NULL,
        nome TEXT NOT NULL,
        descricao TEXT,
        data_aquisicao TEXT NOT NULL,
        valor REAL NOT NULL,
        condicao TEXT,
        foto_path TEXT,
        detalhes_especificos TEXT,
        categoria TEXT,
        FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE
      )
    ''');
    print("bancos de consultas e pets criados");
  }

  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Cria as tabelas de coleção caso esteja atualizando de uma versão antiga
      await _onCreateDB(db, newVersion);
    }
  }

  //MÉTODOS CRUD PARA pets
  Future<int> insertPet(Pet pet) async {
    final db = await database;
    return await db.insert("pets", pet.toMap()); //retorna o ID do pet
  }

  Future<List<Pet>> getPets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "pets",
    ); // recebe todos os pets cadastros
    //converter em objetos
    return maps.map((e) => Pet.fromMap(e)).toList();
    // adiciona elem por elem na lista já convertido em obj
  }

  Future<Pet?> getPetById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      //faz a busca no BD
      "pets",
      where: "id=?",
      whereArgs: [id],
    ); // A partir do ID solicitado
    // Se Encontrado
    if (maps.isNotEmpty) {
      return Pet.fromMap(maps.first); //cria o obj com 1º elementos da list
    } else {
      return null;
    }
  }

  Future<int> deletePet(int id) async {
    final db = await database;
    return await db.delete("pets", where: "id=?", whereArgs: [id]);
    // deleta o pet da tabela que tenha o id igual ao passado pelo parametro
  }

  //métodos CRUDs para Consultas

  Future<int> insertConsulta(Consulta consulta) async {
    final db = await database;
    //insere a consulta no BD
    return await db.insert("consultas", consulta.toMap());
  }

  Future<List<Consulta>> getConsultaForPet(int petId) async {
    final db = await database;
    //Consulta  por pet especifico
    final List<Map<String, dynamic>> maps = await db.query(
      "consultas",
      where: "pet_id = ?",
      whereArgs: [petId],
      orderBy: "data_hora ASC" //ordena pela DAta/Hora
    );
    //converter a map para obj
    return maps.map((e) => Consulta.fromMap(e)).toList();
  }

  Future<int> deleteConsulta(int id) async {
    final db = await database;
    //delete pelo ID
    return await db.delete("consultas", where: "id = ?", whereArgs: [id]);
  }

  // CRUD para collections
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
      where: "id=?",
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

  // CRUD para collection_items
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
      orderBy: "data_aquisicao ASC"
    );
    return maps.map((e) => CollectionItem.fromMap(e)).toList();
  }

  Future<int> deleteCollectionItem(int id) async {
    final db = await database;
    return await db.delete("collection_items", where: "id = ?", whereArgs: [id]);
  }
}
