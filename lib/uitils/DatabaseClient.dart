import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/TodoItem.dart';


class DatabaseHelper {
  final String tableItem = "itemTable";
  final String columnId = "id";
  final String columnItemName = "itemName";
  final String columnDateCreated = "dateCreated";

  static final DatabaseHelper _instance = new DatabaseHelper.internal();


  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "ItemDb.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }


  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableItem($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnDateCreated TEXT)");
  }

  //CRUD - Create Read Update DELETE

  //READ
  Future<int> saveTodoItem(TodoItem item) async {
    //will call get db from above
    var dbClient = await db;

    int result = await dbClient.insert(tableItem, item.toMap());
    return result;
  }

  //GET Items
  Future<List> getAllItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableItem");
    return result.toList();
  }

  //GET Count

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableItem"));
  }

  Future<TodoItem> getTodoItem(int itemId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableItem WHERE $columnId = $itemId");
    if (result.length == 0) return null;
    return new TodoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int itemId) async {
    var dbClient = await db;
    return await dbClient.delete(tableItem, where: "$columnId = ?", whereArgs: [itemId]);
  }

  Future<int> updateItem(TodoItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableItem, item.toMap(),
        where: "$columnId = ? ", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
