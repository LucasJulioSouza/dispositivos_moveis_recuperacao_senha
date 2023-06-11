import 'package:login_with_sqllite/external/database/messages_table_schema.dart';
import 'package:login_with_sqllite/model/messages_model.dart';

abstract class MessageMapper {
  static Map<String, dynamic> toMapMessageDB(MessageModel message) {
    return {
      MessageTableSchema.senderColumn: message.sender,
      MessageTableSchema.recipientColumn: message.recipient,
      MessageTableSchema.contentColumn: message.content,
      MessageTableSchema.timestampColumn: message.timestamp.toIso8601String(),
    };
  }

  static MessageModel fromMapMessageDB(Map<String, dynamic> map) {
    return MessageModel(
      id: map[MessageTableSchema.idColumn],
      sender: map[MessageTableSchema.senderColumn],
      recipient: map[MessageTableSchema.recipientColumn],
      content: map[MessageTableSchema.contentColumn],
      timestamp: DateTime.parse(map[MessageTableSchema.timestampColumn]),
    );
  }

  static MessageModel cloneMessage(MessageModel message) {
    return MessageModel(
      id: message.id,
      sender: message.sender,
      recipient: message.recipient,
      content: message.content,
      timestamp: message.timestamp,
    );
  }
}
