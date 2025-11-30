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
  final List<ClauseResponse> clauses;  
  final List<SignatureResponse> signatures; 
  final List<CompensationResponse> compensations;   
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
        baseAmount: (json['baseAmount'] as num).toInt(),
    
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
    clauses: json['clauses'] != null
        ? (json['clauses'] as List)
            .map((e) => ClauseResponse.fromJson(e))
            .toList()
        : [],
    signatures: json['signatures'] != null
        ? (json['signatures'] as List)
            .map((e) => SignatureResponse.fromJson(e))
            .toList()
        : [],
    compensations: json['compensations'] != null
        ? (json['compensations'] as List)
            .map((e) => CompensationResponse.fromJson(e))
            .toList()
        : [],
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