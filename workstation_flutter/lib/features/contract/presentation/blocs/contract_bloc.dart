import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/features/contract/data/contacts_service.dart';
import 'package:workstation_flutter/features/contract/domain/response/contract_response.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_event.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final ContractAPIService contractService;

  ContractBloc({required this.contractService}) : super(const ContractState()) {
    on<SubmitCreateContract>(_onSubmitCreateContract);
    on<GetContractsByUserId>(_onGetContractsByUserId);
    on<GetActiveContracts>(_onGetActiveContracts);
    on<GetPendingContracts>(_onGetPendingContracts);
    on<AddClauseToContract>(_onAddClauseToContract);
    on<AddSignatureToContract>(_onAddSignatureToContract);
    on<ActivateContract>(_onActivateContract);
    on<ResetContractState>(_onResetContractState);

    on<OnOfficeIdChanged>(_onOfficeIdChanged);
    on<OnOwnerIdChanged>(_onOwnerIdChanged);
    on<OnRenterIdChanged>(_onRenterIdChanged);
    on<OnDescriptionChanged>(_onDescriptionChanged);
    on<OnStartDateChanged>(_onStartDateChanged);
    on<OnEndDateChanged>(_onEndDateChanged);
    on<OnBaseAmountChanged>(_onBaseAmountChanged);
    on<OnLateFeeChanged>(_onLateFeeChanged);
    on<OnInterestRateChanged>(_onInterestRateChanged);
  }

  // ==================== EVENTOS PRINCIPALES ====================

  Future<void> _onSubmitCreateContract(
    SubmitCreateContract event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final createdContract = await contractService.createContract(event.contract);

      emit(state.copyWith(
        status: Status.success,
        selectedContract: createdContract,
        officeId: createdContract.officeId,
        ownerId: createdContract.ownerId,
        renterId: createdContract.renterId,
      ));
    } catch (e) {
      print("🔥 ERROR Bloc (createContract) -> $e");
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error al crear el contrato: ${e.toString()}',
      ));
    }
  }

  Future<void> _onGetContractsByUserId(
    GetContractsByUserId event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final contracts = await contractService.getContractsByUser(event.userId);

      if (contracts.isEmpty) {
        emit(state.copyWith(
          status: Status.success,
          contracts: const [],
          errorMessage: 'No se encontraron contratos para este usuario',
        ));
        return;
      }

      emit(state.copyWith(
        status: Status.success,
        contracts: contracts,
      ));
    } catch (e) {
      print("🔥 ERROR Bloc (getContractsByUserId) -> $e");
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error al cargar los contratos: ${e.toString()}',
      ));
    }
  }

  // ==================== FILTROS LOCALES ====================

  Future<void> _onGetActiveContracts(
    GetActiveContracts event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final allContracts = await contractService.getContractsByUser(event.userId);
      final activeContracts = allContracts.where((c) => c.status == 'ACTIVE').toList();

      emit(state.copyWith(
        status: Status.success,
        contracts: activeContracts,
      ));
    } catch (e) {
      print("🔥 ERROR Bloc (getActiveContracts) -> $e");
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error al cargar contratos activos: ${e.toString()}',
      ));
    }
  }

  Future<void> _onGetPendingContracts(
    GetPendingContracts event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final allContracts = await contractService.getContractsByUser(event.userId);
      final pendingContracts = allContracts.where((c) => c.status == 'PENDING').toList();

      emit(state.copyWith(
        status: Status.success,
        contracts: pendingContracts,
      ));
    } catch (e) {
      print("🔥 ERROR Bloc (getPendingContracts) -> $e");
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error al cargar contratos pendientes: ${e.toString()}',
      ));
    }
  }

  // ==================== ACCIONES ====================

  Future<void> _onAddClauseToContract(
    AddClauseToContract event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final updated = await contractService.addClauseToContract(
        event.contractId,
        event.clause,
      );

      emit(state.copyWith(
        status: Status.success,
        selectedContract: updated,
      ));
    } catch (e) {
      print("🔥 ERROR Bloc (addClauseToContract) -> $e");
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error al agregar la cláusula: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAddSignatureToContract(
    AddSignatureToContract event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final updated = await contractService.addSignatureToContract(
        event.contractId,
        event.signature,
      );

      emit(state.copyWith(
        status: Status.success,
        selectedContract: updated,
      ));
    } catch (e) {
      print("🔥 ERROR Bloc (addSignatureToContract) -> $e");
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error al agregar la firma: ${e.toString()}',
      ));
    }
  }

  Future<void> _onActivateContract(
    ActivateContract event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await contractService.activateContract(event.contractId);
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      print("🔥 ERROR Bloc (activateContract) -> $e");
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error al activar el contrato: ${e.toString()}',
      ));
    }
  }

  void _onResetContractState(
    ResetContractState event,
    Emitter<ContractState> emit,
  ) {
    emit(const ContractState());
  }

  // ==================== FORMULARIO ====================

  void _onOfficeIdChanged(OnOfficeIdChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(officeId: event.officeId));
  }
  void _onOwnerIdChanged(OnOwnerIdChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(ownerId: event.ownerId));
  }
  void _onRenterIdChanged(OnRenterIdChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(renterId: event.renterId));
  }
  void _onDescriptionChanged(OnDescriptionChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(description: event.description));
  }
  void _onStartDateChanged(OnStartDateChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(startDate: event.startDate));
  }
  void _onEndDateChanged(OnEndDateChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(endDate: event.endDate));
  }
  void _onBaseAmountChanged(OnBaseAmountChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(baseAmount: event.baseAmount));
  }
  void _onLateFeeChanged(OnLateFeeChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(lateFee: event.lateFee));
  }
  void _onInterestRateChanged(OnInterestRateChanged event, Emitter<ContractState> emit) {
    emit(state.copyWith(interestRate: event.interestRate));
  }
}
