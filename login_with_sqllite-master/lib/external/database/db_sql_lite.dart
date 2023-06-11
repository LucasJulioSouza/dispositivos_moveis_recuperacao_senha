import 'package:login_with_sqllite/external/database/messages_table_schema.dart';
import 'package:login_with_sqllite/model/messages_mapper.dart';
import 'package:login_with_sqllite/model/messages_model.dart';
import 'package:login_with_sqllite/external/database/user_table_schema.dart';
import 'package:login_with_sqllite/model/user_mapper.dart';
import 'package:login_with_sqllite/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLiteDb {
  //static final SqlLiteDb instance = SqlLiteDb._();
  static Database? _db;

  Future<Database> _open() async {
    if (_db != null) return _db!;

    _db = await _initDB('message.db');
    return _db!;
  }

  Future<String?> getCurrentUserId() async {
    final db = await _open();
    final result = await db.query(
      UserTableSchema.nameTable,
      columns: [UserTableSchema.userIDColumn],
    );

    if (result.isNotEmpty) {
      return result.first[UserTableSchema.userIDColumn] as String?;
    }

    return null;
  }

  Future<void> saveMessage(MessageModel message) async {
    final db = await _open();

    await db.insert(
      MessageTableSchema.nameTable2,
      MessageMapper.toMapMessageDB(message),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MessageModel>> getMessages(String recipient) async {
    final db = await _open();
    final result = await db.query(
      MessageTableSchema.nameTable2,
      where: '${MessageTableSchema.recipientColumn} = ?',
      whereArgs: [recipient],
      orderBy: '${MessageTableSchema.timestampColumn} ASC',
    );

    return result.map((map) => MessageMapper.fromMapMessageDB(map)).toList();
  }

  Future<void> atualizarSenhaUsuario(String email, String newPassword) async {
    var dbClient = await dbInstance;
    var res = await dbClient.update(
      UserTableSchema.nameTable,
      {UserTableSchema.userPasswordColumn: newPassword},
      where: '${UserTableSchema.userEmailColumn} = ?',
      whereArgs: [email],
    );
  }

  Future<bool> verificarEmailExiste(String email) async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT COUNT(*) FROM ${UserTableSchema.nameTable} WHERE "
      "${UserTableSchema.userEmailColumn} = '$email'",
    );

    if (res.isNotEmpty) {
      var count = Sqflite.firstIntValue(res);
      return count! > 0;
    }

    return false;
  }

  //SqlLiteDb._();
  Future<Database> get dbInstance async {
    // retorna a intancia se já tiver sido criada
    if (_db != null) return _db!;

    _db = await _initDB('user.db');
    return _db!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _onCreateSchema(db, version);
      },
    );

    return database;
  }

  // executa script de criacao de tabelas
  Future<void> _onCreateSchema(Database db, int? versao) async {
    await db.execute(UserTableSchema.createUserTableScript());
    await db.execute(UserTableSchema.createMessagesTable());
  }

  Future<int> saveUser(UserModel user) async {
    var dbClient = await dbInstance;
    var res = await dbClient.insert(
      UserTableSchema.nameTable,
      UserMapper.toMapBD(user),
    );

    return res;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await dbInstance;
    var res = await dbClient.update(
      UserTableSchema.nameTable,
      UserMapper.toMapBD(user),
      where: '${UserTableSchema.userIDColumn} = ?',
      whereArgs: [user.userId],
    );
    return res;
  }

  Future<int> deleteUser(String userId) async {
    var dbClient = await dbInstance;
    var res = await dbClient.delete(
      UserTableSchema.nameTable,
      where: '${UserTableSchema.userIDColumn} = ?',
      whereArgs: [userId],
    );
    return res;
  }

  Future<UserModel?> getLoginUser(String userId, String password) async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT * FROM ${UserTableSchema.nameTable} WHERE "
      "${UserTableSchema.userIDColumn} = '$userId' AND "
      "${UserTableSchema.userPasswordColumn} = '$password'",
    );

    if (res.isNotEmpty) {
      return UserMapper.fromMapBD(res.first);
    }

    return null;
  }
}
