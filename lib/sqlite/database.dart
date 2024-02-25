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
    String path = join(await getDatabasesPath(), 'ajustes_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> clearAjustes() async {
    final Database db = await database;
    await db.delete('ajustes');
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE ajustes (
        id INTEGER PRIMARY KEY,
        iniciarSesionConHuella INTEGER,
        mantenerSesionIniciada INTEGER,
        usuario TEXT,
        password TEXT
      )
      ''',
    );
  }

  Future<void> saveAjustes(
      {required bool iniciarSesionConHuella,
      required bool mantenerSesionIniciada,
      String? usuario,
      String? password}) async {
    final Database db = await database;

    await db.insert(
      'ajustes',
      {
        'iniciarSesionConHuella': iniciarSesionConHuella ? 1 : 0,
        'mantenerSesionIniciada': mantenerSesionIniciada ? 1 : 0,
        'usuario': usuario,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getAjustes() async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('ajustes');
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
