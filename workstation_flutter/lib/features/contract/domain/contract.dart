class Contract {
  final String officeId;
  final String ownerId;
  final String renterId;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int baseAmount;
  final double lateFee;
  final double interestRate;

  Contract({
    required this.officeId,
    required this.ownerId,
    required this.renterId,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.baseAmount,
    required this.lateFee,
    required this.interestRate,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      officeId: json['officeId'],
      ownerId: json['ownerId'],
      renterId: json['renterId'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      baseAmount: (json['baseAmount']),
      lateFee: (json['lateFee'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'officeId': officeId,
      'ownerId': ownerId,
      'renterId': renterId,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'baseAmount': baseAmount,
      'lateFee': lateFee,
      'interestRate': interestRate,
    };
  }
}
