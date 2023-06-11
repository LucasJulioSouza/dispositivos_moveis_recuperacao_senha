abstract class UserTableSchema {
  static const String nameTable = "user";
  static const String userIDColumn = 'id';
  static const String userNameColumn = 'name';
  static const String userEmailColumn = 'email';
  static const String userPasswordColumn = 'password';
  static const String nameTable2 = "messages";
  static const String idColumn = "id";
  static const String senderColumn = "sender";
  static const String recipientColumn = "recipient";
  static const String contentColumn = "content";
  static const String timestampColumn = "timestamp";

  static String createUserTableScript() => '''
    CREATE TABLE $nameTable (
        $userIDColumn TEXT NOT NULL PRIMARY KEY, 
        $userNameColumn TEXT NOT NULL, 
        $userEmailColumn TEXT NOT NULL,
        $userPasswordColumn TEXT NOT NULL
        )
      ''';
  static String createMessagesTable() => '''
      CREATE TABLE $nameTable2 (
        $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $senderColumn TEXT,
        $recipientColumn TEXT,
        $contentColumn TEXT,
        $timestampColumn TEXT
      )
    ''';
}
