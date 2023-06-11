class MessageModel {
  final int id;
  final String sender;
  final String recipient;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.content,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'UserModel(userId: $id, sender: $sender, recipient: $recipient, content: $content, timestamp: $timestamp)';
  }
}
