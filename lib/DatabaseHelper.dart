import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rememberdev/Providerbase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'guide.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Função para criar todas as tabelas necessárias
  Future<void> _onCreate(Database db, int version) async {
    await _createUserTable(db);
    await _createPatternTable(db);
    await _createCategoryTable(db);
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<void> _createPatternTable(Database db) async {
    await db.execute('''
    CREATE TABLE pattern (
      id INTEGER PRIMARY KEY,
      description TEXT,
      category TEXT,
      username TEXT,
      datetime TEXT
    )
  ''');
  }

  Future<void> _createCategoryTable(Database db) async {
    await db.execute('''
    CREATE TABLE category (
      id INTEGER PRIMARY KEY,
      description TEXT,
      username TEXT,
      datetime TEXT
    )
  ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('users', row);
  }

  Future<int> insertPattern(Padrao padrao) async {
    Database db = await instance.database;
    //await _createPatternTable(db);
    return await db.insert('pattern', padrao.toMap());
  }

  Future<int> insertCategory(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('category', row);
  }

  Future<int> deleteCategory(int categoryId) async {
    Database db = await instance.database;
    return await db
        .delete('category', where: 'id = ?', whereArgs: [categoryId]);
  }

  Future<int> deletePattern(int categoryId) async {
    Database db = await instance.database;
    return await db.delete('pattern', where: 'id = ?', whereArgs: [categoryId]);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> queryAllCategory() async {
    Database db = await instance.database;
    return await db.query('category');
  }

  Future<List<Map<String, dynamic>>> queryAllPattern() async {
    Database db = await instance.database;
    return await db.query('pattern');
  }
}

class Padrao {
  int? id; // O ID será gerado automaticamente pelo SQLite
  String descricao;
  String categoria;
  String loggedInUsername;
  DateTime dataHoraAtual;

  Padrao({
    this.id,
    required this.descricao,
    required this.categoria,
    required this.loggedInUsername,
    required this.dataHoraAtual,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': descricao,
      'category': categoria,
      'username': loggedInUsername,
      'datetime': dataHoraAtual.toLocal().toString(),
    };
  }
}
