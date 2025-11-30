abstract class ContractDetailEvent {
  const ContractDetailEvent();
}

/// Evento para cargar el contrato activo por officeId
class LoadContractByOfficeId extends ContractDetailEvent {
  final String officeId;
  
  const LoadContractByOfficeId({required this.officeId});
}

/// Evento para cargar detalles de la oficina
class LoadOfficeDetails extends ContractDetailEvent {
  final String officeId;
  
  const LoadOfficeDetails({required this.officeId});
}

/// Evento para cargar detalles del owner
class LoadOwnerDetails extends ContractDetailEvent {
  final String ownerId;
  
  const LoadOwnerDetails({required this.ownerId});
}

/// Evento para cargar detalles del renter
class LoadRenterDetails extends ContractDetailEvent {
  final String renterId;
  
  const LoadRenterDetails({required this.renterId});
}

/// Evento para resetear el estado
class ResetContractDetail extends ContractDetailEvent {
  const ResetContractDetail();
}