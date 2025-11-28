import 'package:workstation_flutter/features/contract/domain/clause.dart';
import 'package:workstation_flutter/features/contract/domain/contract.dart';
import 'package:workstation_flutter/features/contract/domain/signature.dart';

abstract class ContractEvent {
  const ContractEvent();
}

/// Crea un nuevo contrato
class SubmitCreateContract extends ContractEvent {
  final Contract contract;
  const SubmitCreateContract({required this.contract});
}

/// Carga un contrato específico por ID
class LoadContractById extends ContractEvent {
  final String contractId;
  const LoadContractById({required this.contractId});
}

/// Obtiene todos los contratos de un usuario
class GetContractsByUserId extends ContractEvent {
  final String userId;
  const GetContractsByUserId({required this.userId});
}

/// Obtiene solo los contratos activos de un usuario
class GetActiveContracts extends ContractEvent {
  final String userId;
  const GetActiveContracts({required this.userId});
}

/// Obtiene contratos pendientes de firma
class GetPendingContracts extends ContractEvent {
  final String userId;
  const GetPendingContracts({required this.userId});
}

/// Agrega una cláusula a un contrato
class AddClauseToContract extends ContractEvent {
  final String contractId;
  final Clause clause;
  const AddClauseToContract({
    required this.contractId,
    required this.clause,
  });
}

/// Agrega una firma a un contrato
class AddSignatureToContract extends ContractEvent {
  final String contractId;
  final Signature signature;
  const AddSignatureToContract({
    required this.contractId,
    required this.signature,
  });
}

/// Activa un contrato
class ActivateContract extends ContractEvent {
  final String contractId;
  const ActivateContract({required this.contractId});
}

/// Resetea el estado del contrato
class ResetContractState extends ContractEvent {
  const ResetContractState();
}

/// Eventos para actualizar campos individuales del formulario
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
  final double baseAmount;
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