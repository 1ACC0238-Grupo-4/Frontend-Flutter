import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/features/contract/data/contacts_service.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_detail_event.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_detail_state.dart';
import 'package:workstation_flutter/features/profile/data/user_service.dart';
import 'package:workstation_flutter/features/search/data/offices_service.dart';

class ContractDetailBloc
    extends Bloc<ContractDetailEvent, ContractDetailState> {
  final ContractAPIService contractService;
  final OfficeAPIService officeService;
  final UserService userService;

  ContractDetailBloc({
    required this.contractService,
    required this.officeService,
    required this.userService,
  }) : super(const ContractDetailState()) {
    on<LoadContractByOfficeId>(_onLoadContractByOfficeId);
    on<LoadOfficeDetails>(_onLoadOfficeDetails);
    on<LoadOwnerDetails>(_onLoadOwnerDetails);
    on<LoadRenterDetails>(_onLoadRenterDetails);
    on<ResetContractDetail>(_onResetContractDetail);
  }

  Future<void> _onLoadContractByOfficeId(
    LoadContractByOfficeId event,
    Emitter<ContractDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final allContracts = await contractService.getAllActiveContracts();
      final matchingContract = allContracts.firstWhere(
        (contract) => contract.officeId == event.officeId,
        orElse: () =>
            throw Exception('No se encontró contrato activo para esta oficina'),
      );

      emit(state.copyWith(status: Status.success, contract: matchingContract));

      await Future.delayed(const Duration(milliseconds: 500));
      add(LoadOfficeDetails(officeId: matchingContract.officeId));

      await Future.delayed(const Duration(milliseconds: 500));
      add(LoadOwnerDetails(ownerId: matchingContract.ownerId));

      await Future.delayed(const Duration(milliseconds: 1000));
      add(LoadRenterDetails(renterId: matchingContract.renterId));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadOfficeDetails(
    LoadOfficeDetails event,
    Emitter<ContractDetailState> emit,
  ) async {
    emit(state.copyWith(officeStatus: Status.loading));
    try {
      final office = await officeService.getOfficeById(event.officeId);
      emit(state.copyWith(officeStatus: Status.success, office: office));
    } catch (e) {
      emit(state.copyWith(officeStatus: Status.failure));
    }
  }

  Future<void> _onLoadOwnerDetails(
    LoadOwnerDetails event,
    Emitter<ContractDetailState> emit,
  ) async {
    emit(state.copyWith(ownerStatus: Status.loading));

    try {
      final owner = await userService.getUserById(event.ownerId);

      emit(state.copyWith(ownerStatus: Status.success, owner: owner));
    } catch (e) {
      emit(state.copyWith(ownerStatus: Status.failure));
    }
  }

  Future<void> _onLoadRenterDetails(
    LoadRenterDetails event,
    Emitter<ContractDetailState> emit,
  ) async {
    emit(state.copyWith(renterStatus: Status.loading));

    try {
      final renter = await userService.getUserById(event.renterId);

      emit(state.copyWith(renterStatus: Status.success, renter: renter));
    } catch (e) {
      emit(state.copyWith(renterStatus: Status.failure));
    }
  }

  void _onResetContractDetail(
    ResetContractDetail event,
    Emitter<ContractDetailState> emit,
  ) {
    emit(const ContractDetailState());
  }
}
