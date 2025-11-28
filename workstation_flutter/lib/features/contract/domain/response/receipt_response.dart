class ReceiptResponse {
  final String id;
  final String receiptNumber;
  final double baseAmount;
  final double compensationAdjustments;
  final double finalAmount;
  final DateTime issuedAt;
  final DateTime updatedAt;
  final String notes;
  final String status;

  ReceiptResponse({
    required this.id,
    required this.receiptNumber,
    required this.baseAmount,
    required this.compensationAdjustments,
    required this.finalAmount,
    required this.issuedAt,
    required this.updatedAt,
    required this.notes,
    required this.status,
  });

  factory ReceiptResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptResponse(
      id: json['id'],
      receiptNumber: json['receiptNumber'],
      baseAmount: (json['baseAmount'] as num).toDouble(),
      compensationAdjustments: (json['compensationAdjustments'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
      issuedAt: DateTime.parse(json['issuedAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      notes: json['notes'],
      status: json['status'],
    );
  }
}
