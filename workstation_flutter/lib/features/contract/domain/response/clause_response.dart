class ClauseResponse {
  final String id;
  final String name;
  final String content;
  final int order;
  final bool mandatory;

  ClauseResponse({
    required this.id,
    required this.name,
    required this.content,
    required this.order,
    required this.mandatory,
  });

  factory ClauseResponse.fromJson(Map<String, dynamic> json) {
    return ClauseResponse(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      order: json['order'],
      mandatory: json['mandatory'],
    );
  }
}
