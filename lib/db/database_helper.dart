import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            subject TEXT,
            title TEXT,
            content TEXT,
            label TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes({String? subjectFilter, String? labelFilter}) async {
    final db = await database;
    String whereString = '';
    List<dynamic> whereArguments = [];

    if (subjectFilter != null && subjectFilter.isNotEmpty) {
      whereString += 'subject = ?';
      whereArguments.add(subjectFilter);
    }
    if (labelFilter != null && labelFilter.isNotEmpty) {
      if (whereString.isNotEmpty) whereString += ' AND ';
      whereString += 'label = ?';
      whereArguments.add(labelFilter);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: whereString.isNotEmpty ? whereString : null,
      whereArgs: whereArguments.isNotEmpty ? whereArguments : null,
    );

    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }
}
