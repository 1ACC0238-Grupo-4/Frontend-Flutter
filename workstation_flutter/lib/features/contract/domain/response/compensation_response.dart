class CompensationResponse {
  final String id;
  final String issuerId;
  final String receiverId;
  final double amount;
  final String reason;
  final DateTime createdAt;
  final String status;

  CompensationResponse({
    required this.id,
    required this.issuerId,
    required this.receiverId,
    required this.amount,
    required this.reason,
    required this.createdAt,
    required this.status,
  });

  factory CompensationResponse.fromJson(Map<String, dynamic> json) {
    return CompensationResponse(
      id: json['id'],
      issuerId: json['issuerId'],
      receiverId: json['receiverId'],
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }
}
