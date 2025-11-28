import 'package:workstation_flutter/core/enums/status.dart';

import 'package:workstation_flutter/features/contract/domain/response/contract_response.dart';
import 'package:workstation_flutter/features/contract/domain/response/clause_response.dart';
import 'package:workstation_flutter/features/contract/domain/response/signature_response.dart';


class ContractState {
  final Status status;
  final String officeId;
  final String ownerId;
  final String renterId;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final double baseAmount;
  final double lateFee;
  final double interestRate;

  final List<ClauseResponse> clauses;
  final List<SignatureResponse> signatures;
  final ContractResponse? selectedContract; 
  final List<ContractResponse> contracts;  
  final String? errorMessage;

  const ContractState({
    this.status = Status.initial,
    this.officeId = '',
    this.ownerId = '',
    this.renterId = '',
    this.description = '',
    this.startDate,
    this.endDate,
    this.baseAmount = 0,
    this.lateFee = 0,
    this.interestRate = 0,
    this.clauses = const [], 
    this.signatures = const [], 
    this.selectedContract, 
    this.contracts = const [],
    this.errorMessage,
  });

  ContractState copyWith({
    Status? status,
    String? officeId,
    String? ownerId,
    String? renterId,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? baseAmount,
    double? lateFee,
    double? interestRate,
    
    List<ClauseResponse>? clauses,
    List<SignatureResponse>? signatures,
    ContractResponse? selectedContract,
    List<ContractResponse>? contracts,
    String? errorMessage,
  }) {
    return ContractState(
      status: status ?? this.status,
      officeId: officeId ?? this.officeId,
      ownerId: ownerId ?? this.ownerId,
      renterId: renterId ?? this.renterId,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      baseAmount: baseAmount ?? this.baseAmount,
      lateFee: lateFee ?? this.lateFee,
      interestRate: interestRate ?? this.interestRate,
      
      clauses: clauses ?? this.clauses,
      signatures: signatures ?? this.signatures,
      selectedContract: selectedContract ?? this.selectedContract,
      contracts: contracts ?? this.contracts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  

  bool get isFormValid {
    return officeId.isNotEmpty &&
        ownerId.isNotEmpty &&
        renterId.isNotEmpty &&
        description.isNotEmpty &&
        startDate != null &&
        endDate != null &&
        baseAmount > 0 &&
        startDate!.isBefore(endDate!);
  }

  
  bool get hasAllSignatures {
    if (selectedContract == null) return false;
    return selectedContract!.signatures.length >= 2; 
  }

  bool get isActive {
    if (selectedContract == null) return false;
    return selectedContract!.status == 'ACTIVE'; 
  }
}