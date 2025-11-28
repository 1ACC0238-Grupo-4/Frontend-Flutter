class Clause {
  final String name;
  final String content;
  final int order;
  final bool mandatory;

  Clause({
    required this.name,
    required this.content,
    required this.order,
    required this.mandatory,
  });

  factory Clause.fromJson(Map<String, dynamic> json) {
    return Clause(
      name: json['name'],
      content: json['content'],
      order: json['order'],
      mandatory: json['mandatory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'content': content,
      'order': order,
      'mandatory': mandatory,
    };
  }
}
