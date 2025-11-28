class SignatureResponse {
  final String id;
  final String signerId;
  final DateTime signedAt;
  final String signatureHash;

  SignatureResponse({
    required this.id,
    required this.signerId,
    required this.signedAt,
    required this.signatureHash,
  });

  factory SignatureResponse.fromJson(Map<String, dynamic> json) {
    return SignatureResponse(
      id: json['id'],
      signerId: json['signerId'],
      signedAt: DateTime.parse(json['signedAt']),
      signatureHash: json['signatureHash'],
    );
  }
}
