import 'package:workstation_flutter/features/contract/domain/clause.dart';
import 'package:workstation_flutter/features/contract/domain/contract.dart';
import 'package:workstation_flutter/features/contract/domain/signature.dart';

abstract class ContractEvent {
  const ContractEvent();
}

class SubmitCreateContract extends ContractEvent {
  final Contract contract;
  const SubmitCreateContract({required this.contract});
}

class LoadContractById extends ContractEvent {
  final String contractId;
  const LoadContractById({required this.contractId});
}

class GetContractsByUserId extends ContractEvent {
  final String userId;
  const GetContractsByUserId({required this.userId});
}

class GetActiveContracts extends ContractEvent {
  final String userId;
  const GetActiveContracts({required this.userId});
}

class GetPendingContracts extends ContractEvent {
  final String userId;
  const GetPendingContracts({required this.userId});
}

class AddClauseToContract extends ContractEvent {
  final String contractId;
  final Clause clause;
  const AddClauseToContract({required this.contractId, required this.clause});
}

class AddSignatureToContract extends ContractEvent {
  final String contractId;
  final Signature signature;
  const AddSignatureToContract({
    required this.contractId,
    required this.signature,
  });
}

class ActivateContract extends ContractEvent {
  final String contractId;
  const ActivateContract({required this.contractId});
}

class ResetContractState extends ContractEvent {
  const ResetContractState();
}

class OnOfficeIdChanged extends ContractEvent {
  final String officeId;
  const OnOfficeIdChanged({required this.officeId});
}

class OnOwnerIdChanged extends ContractEvent {
  final String ownerId;
  const OnOwnerIdChanged({required this.ownerId});
}

class OnRenterIdChanged extends ContractEvent {
  final String renterId;
  const OnRenterIdChanged({required this.renterId});
}

class OnDescriptionChanged extends ContractEvent {
  final String description;
  const OnDescriptionChanged({required this.description});
}

class OnStartDateChanged extends ContractEvent {
  final DateTime startDate;
  const OnStartDateChanged({required this.startDate});
}

class OnEndDateChanged extends ContractEvent {
  final DateTime endDate;
  const OnEndDateChanged({required this.endDate});
}

class OnBaseAmountChanged extends ContractEvent {
  final int baseAmount;
  const OnBaseAmountChanged({required this.baseAmount});
}

class OnLateFeeChanged extends ContractEvent {
  final double lateFee;
  const OnLateFeeChanged({required this.lateFee});
}

class OnInterestRateChanged extends ContractEvent {
  final double interestRate;
  const OnInterestRateChanged({required this.interestRate});
}
