abstract class ContractDetailEvent {
  const ContractDetailEvent();
}

class LoadContractByOfficeId extends ContractDetailEvent {
  final String officeId;

  const LoadContractByOfficeId({required this.officeId});
}

class LoadOfficeDetails extends ContractDetailEvent {
  final String officeId;

  const LoadOfficeDetails({required this.officeId});
}

class LoadOwnerDetails extends ContractDetailEvent {
  final String ownerId;

  const LoadOwnerDetails({required this.ownerId});
}

class LoadRenterDetails extends ContractDetailEvent {
  final String renterId;

  const LoadRenterDetails({required this.renterId});
}

class ResetContractDetail extends ContractDetailEvent {
  const ResetContractDetail();
}
