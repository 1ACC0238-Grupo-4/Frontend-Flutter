import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/features/contract/domain/response/contract_response.dart';
import 'package:workstation_flutter/features/offices/domain/office.dart';
import 'package:workstation_flutter/features/profile/domain/user.dart';
import 'package:workstation_flutter/features/profile/domain/user_response.dart';

class ContractDetailState {
  final Status status;
  final ContractResponse? contract;
  final Office? office;
  final UserResponse? owner;
  final UserResponse? renter;
  final String? errorMessage;
  
  final Status officeStatus;
  final Status ownerStatus;
  final Status renterStatus;

  const ContractDetailState({
    this.status = Status.initial,
    this.contract,
    this.office,
    this.owner,
    this.renter,
    this.errorMessage,
    this.officeStatus = Status.initial,
    this.ownerStatus = Status.initial,
    this.renterStatus = Status.initial,
  });

  ContractDetailState copyWith({
    Status? status,
    ContractResponse? contract,
    Office? office,
    UserResponse? owner,
    UserResponse? renter,
    String? errorMessage,
    Status? officeStatus,
    Status? ownerStatus,
    Status? renterStatus,
  }) {
    return ContractDetailState(
      status: status ?? this.status,
      contract: contract ?? this.contract,
      office: office ?? this.office,
      owner: owner ?? this.owner,
      renter: renter ?? this.renter,
      errorMessage: errorMessage ?? this.errorMessage,
      officeStatus: officeStatus ?? this.officeStatus,
      ownerStatus: ownerStatus ?? this.ownerStatus,
      renterStatus: renterStatus ?? this.renterStatus,
    );
  }
  
  bool get isFullyLoaded =>
      contract != null &&
      office != null &&
      owner != null &&
      renter != null;
}