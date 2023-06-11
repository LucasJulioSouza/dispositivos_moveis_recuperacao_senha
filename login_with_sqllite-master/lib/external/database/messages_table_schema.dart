abstract class MessageTableSchema {
  static const String nameTable2 = "messages";
  static const String idColumn = "id";
  static const String senderColumn = "sender";
  static const String recipientColumn = "recipient";
  static const String contentColumn = "content";
  static const String timestampColumn = "timestamp";

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
