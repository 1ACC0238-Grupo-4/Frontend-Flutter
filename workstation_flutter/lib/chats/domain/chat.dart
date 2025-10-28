class Chat {
  final String id;
  final String contactName;
  final String? lastMessage;
  final String? contactImageUrl;
  final DateTime? lastMessageTime;

  Chat({
    required this.id,
    required this.contactName,
    this.lastMessage,
    this.contactImageUrl,
    this.lastMessageTime,
  });
}