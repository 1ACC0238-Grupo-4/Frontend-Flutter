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
    print('🔍 ====== BUSCANDO CONTRATO POR OFFICE ID ======');
    print('🏢 Office ID: ${event.officeId}');

    emit(state.copyWith(status: Status.loading));

    try {
      // Obtener todos los contratos activos
      final allContracts = await contractService.getAllActiveContracts();
      print('📋 Total contratos activos: ${allContracts.length}');

      // Buscar el contrato que coincida con el officeId
      final matchingContract = allContracts.firstWhere(
        (contract) => contract.officeId == event.officeId,
        orElse: () =>
            throw Exception('No se encontró contrato activo para esta oficina'),
      );

      print('✅ Contrato encontrado:');
      print('   - Contract ID: ${matchingContract.id}');
      print('   - Office ID: ${matchingContract.officeId}');
      print('   - Owner ID: ${matchingContract.ownerId}');
      print('   - Renter ID: ${matchingContract.renterId}');
      print('   - Status: ${matchingContract.status}');
      print('================================================\n');

      emit(state.copyWith(status: Status.success, contract: matchingContract));

      // ✅ CARGAR DETALLES CON DELAYS ENTRE CADA REQUEST
      // Cargar oficina primero
      await Future.delayed(const Duration(milliseconds: 500));
      add(LoadOfficeDetails(officeId: matchingContract.officeId));

      // ⏱️ Esperar 500ms antes de cargar owner
      await Future.delayed(const Duration(milliseconds: 500));
      add(LoadOwnerDetails(ownerId: matchingContract.ownerId));

      // ⏱️ Esperar otros 500ms antes de cargar renter
      await Future.delayed(const Duration(milliseconds: 1000));
      add(LoadRenterDetails(renterId: matchingContract.renterId));
    } catch (e) {
      print('❌ Error al buscar contrato: $e');
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadOfficeDetails(
    LoadOfficeDetails event,
    Emitter<ContractDetailState> emit,
  ) async {
    print('🏢 Cargando detalles de oficina: ${event.officeId}');

    emit(state.copyWith(officeStatus: Status.loading));

    try {
      final office = await officeService.getOfficeById(event.officeId);

      print('✅ Oficina cargada: ${office.location}');

      emit(state.copyWith(officeStatus: Status.success, office: office));
    } catch (e) {
      print('❌ Error al cargar oficina: $e');
      emit(state.copyWith(officeStatus: Status.failure));
    }
  }

  Future<void> _onLoadOwnerDetails(
    LoadOwnerDetails event,
    Emitter<ContractDetailState> emit,
  ) async {
    print('👤 Cargando detalles de owner: ${event.ownerId}');

    emit(state.copyWith(ownerStatus: Status.loading));

    try {
      final owner = await userService.getUserById(event.ownerId);

      print('✅ Owner cargado: ${owner.firstName}');

      emit(state.copyWith(ownerStatus: Status.success, owner: owner));
    } catch (e) {
      print('❌ Error al cargar owner: $e');
      emit(state.copyWith(ownerStatus: Status.failure));
    }
  }

  Future<void> _onLoadRenterDetails(
    LoadRenterDetails event,
    Emitter<ContractDetailState> emit,
  ) async {
    print('👤 Cargando detalles de renter: ${event.renterId}');

    emit(state.copyWith(renterStatus: Status.loading));

    try {
      final renter = await userService.getUserById(event.renterId);

      print('✅ Renter cargado: ${renter.firstName}');

      emit(state.copyWith(renterStatus: Status.success, renter: renter));
    } catch (e) {
      print('❌ Error al cargar renter: $e');
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
