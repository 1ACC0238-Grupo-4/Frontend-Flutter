import 'package:workstation_flutter/features/contract/domain/contract.dart';
import 'package:workstation_flutter/features/contract/domain/response/clause_response.dart';
import 'package:workstation_flutter/features/contract/domain/response/compensation_response.dart';
import 'package:workstation_flutter/features/contract/domain/response/receipt_response.dart';
import 'package:workstation_flutter/features/contract/domain/response/signature_response.dart';

class ContractResponse {
  final String id;
  final String officeId;
  final String ownerId;
  final String renterId;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int baseAmount;
  final double lateFee;
  final double interestRate;
  final String status;
  final DateTime createdAt;
  final DateTime? activatedAt;
  final DateTime? terminatedAt;
  final List<ClauseResponse> clauses;  // ✅ Mantener como lista pero manejar null en fromJson
  final List<SignatureResponse> signatures;  // ✅ Mantener como lista pero manejar null en fromJson
  final List<CompensationResponse> compensations;  // ✅ Mantener como lista pero manejar null en fromJson
  final ReceiptResponse? receipt;

  ContractResponse({
    required this.id,
    required this.officeId,
    required this.ownerId,
    required this.renterId,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.baseAmount,
    required this.lateFee,
    required this.interestRate,
    required this.status,
    required this.createdAt,
    this.activatedAt,
    this.terminatedAt,
    required this.clauses,
    required this.signatures,
    required this.compensations,
    this.receipt,
  });

  factory ContractResponse.fromJson(Map<String, dynamic> json) {
    return ContractResponse(
      id: json['id'],
      officeId: json['officeId'],
      ownerId: json['ownerId'],
      renterId: json['renterId'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      baseAmount: json['baseAmount'],
      lateFee: (json['lateFee'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      activatedAt: json['activatedAt'] != null 
          ? DateTime.parse(json['activatedAt']) 
          : null,
      terminatedAt: json['terminatedAt'] != null 
          ? DateTime.parse(json['terminatedAt']) 
          : null,
      // ✅ CAMBIO: Manejar null devolviendo lista vacía
      clauses: json['clauses'] != null
          ? (json['clauses'] as List)
              .map((e) => ClauseResponse.fromJson(e))
              .toList()
          : [],  // ✅ Lista vacía si es null
      signatures: json['signatures'] != null
          ? (json['signatures'] as List)
              .map((e) => SignatureResponse.fromJson(e))
              .toList()
          : [],  // ✅ Lista vacía si es null
      compensations: json['compensations'] != null
          ? (json['compensations'] as List)
              .map((e) => CompensationResponse.fromJson(e))
              .toList()
          : [],  // ✅ Lista vacía si es null
      receipt: json['receipt'] != null 
          ? ReceiptResponse.fromJson(json['receipt']) 
          : null,
    );
  }

  Contract toEntity() {
    return Contract(
      officeId: officeId,
      ownerId: ownerId,
      renterId: renterId,
      description: description,
      startDate: startDate,
      endDate: endDate,
      baseAmount: baseAmount,
      lateFee: lateFee,
      interestRate: interestRate,
    );
  }
}