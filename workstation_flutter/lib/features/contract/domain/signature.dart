class Signature {
  final String signerId;
  final String signatureHash;

  Signature({
    required this.signerId,
    required this.signatureHash,
  });

  factory Signature.fromJson(Map<String, dynamic> json) {
    return Signature(
      signerId: json['signerId'],
      signatureHash: json['signatureHash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signerId': signerId,
      'signatureHash': signatureHash,
    };
  }
}
