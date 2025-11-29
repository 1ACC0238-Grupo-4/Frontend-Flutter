import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/features/offices/domain/office.dart';
import 'package:workstation_flutter/features/search/data/offices_service.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_event.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final OfficeAPIService officeService;
  List<Office> _allOffices = [];

  SearchBloc({required this.officeService}) : super(const SearchState()) {
    on<LoadAllOffices>(_onLoadAllOffices);
    on<SearchOfficesByLocation>(_onSearchOfficesByLocation);
    on<OnLocationIdChanged>(_onLocationIdChanged);
    on<FilterAvailableOffices>(_onFilterAvailableOffices);
    on<OnMinCapacityChanged>(_onMinCapacityChanged);
    on<OnMinPriceChanged>(_onMinPriceChanged);
    on<OnMaxPriceChanged>(_onMaxPriceChanged);
    on<OnAvailabilityChanged>(_onAvailabilityChanged);
    on<ApplyFilters>(_onApplyFilters);
    on<GetOfficeById>(_onGetOfficeById);
    on<ResetSearch>(_onResetSearch);
    on<LoadUnavailableOffices>(_onLoadUnavailableOffices);
  }

  Future<void> _onLoadAllOffices(
    LoadAllOffices event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      _allOffices = await officeService.getAllOffices();

      if (_allOffices.isEmpty) {
        emit(
          state.copyWith(
            status: Status.success,
            offices: [],
            errorMessage: 'No hay oficinas disponibles',
          ),
        );
        return;
      }

      emit(state.copyWith(status: Status.success, offices: _allOffices));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchOfficesByLocation(
    SearchOfficesByLocation event,
    Emitter<SearchState> emit,
  ) async {
    if (state.locationId.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'Por favor ingresa una ubicación',
        ),
      );
      return;
    }

    emit(state.copyWith(status: Status.loading));
    try {
      final offices = await officeService.getOfficesByLocation(
        state.locationId,
      );

      if (offices.isEmpty) {
        emit(
          state.copyWith(
            status: Status.success,
            offices: [],
            errorMessage: 'No se encontraron oficinas en esta ubicación',
          ),
        );
        return;
      }

      emit(state.copyWith(status: Status.success, offices: offices));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  void _onLocationIdChanged(
    OnLocationIdChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(locationId: event.locationId));
  }

  Future<void> _onFilterAvailableOffices(
    FilterAvailableOffices event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      List<Office> _offices = await officeService.getAllOffices();
      final available = _offices
          .where((office) => office.available == true)
          .toList();

      if (available.isEmpty) {
        emit(
          state.copyWith(
            status: Status.success,
            offices: [],
            errorMessage: 'No hay oficinas disponibles en este momento',
          ),
        );
        return;
      }

      emit(state.copyWith(status: Status.success, offices: available));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  void _onMinCapacityChanged(
    OnMinCapacityChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(minCapacity: event.minCapacity));
  }

  void _onMinPriceChanged(OnMinPriceChanged event, Emitter<SearchState> emit) {
    emit(state.copyWith(minPrice: event.minPrice));
  }

  void _onMaxPriceChanged(OnMaxPriceChanged event, Emitter<SearchState> emit) {
    emit(state.copyWith(maxPrice: event.maxPrice));
  }

  void _onAvailabilityChanged(
    OnAvailabilityChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(onlyAvailable: event.onlyAvailable));
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      if (_allOffices.isEmpty) {
        _allOffices = await officeService.getAllOffices();
      }

      List<Office> filteredOffices = List.from(_allOffices);

      if (state.locationId.isNotEmpty) {
        filteredOffices = await officeService.getOfficesByLocation(
          state.locationId,
        );
      }

      if (state.onlyAvailable) {
        filteredOffices = filteredOffices
            .where((office) => office.available)
            .toList();
      }

      if (state.minCapacity != null) {
        filteredOffices = filteredOffices
            .where((office) => office.capacity >= state.minCapacity!)
            .toList();
      }

      if (state.minPrice != null && state.maxPrice != null) {
        filteredOffices = filteredOffices
            .where(
              (office) =>
                  office.costPerDay >= state.minPrice! &&
                  office.costPerDay <= state.maxPrice!,
            )
            .toList();
      } else if (state.minPrice != null) {
        filteredOffices = filteredOffices
            .where((office) => office.costPerDay >= state.minPrice!)
            .toList();
      } else if (state.maxPrice != null) {
        filteredOffices = filteredOffices
            .where((office) => office.costPerDay <= state.maxPrice!)
            .toList();
      }

      if (filteredOffices.isEmpty) {
        emit(
          state.copyWith(
            status: Status.success,
            offices: [],
            errorMessage:
                'No se encontraron oficinas con los filtros aplicados',
          ),
        );
        return;
      }

      emit(state.copyWith(status: Status.success, offices: filteredOffices));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onGetOfficeById(
    GetOfficeById event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final office = await officeService.getOfficeById(event.officeId);
      emit(state.copyWith(status: Status.success, selectedOffice: office));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  void _onResetSearch(ResetSearch event, Emitter<SearchState> emit) {
    emit(SearchState(status: Status.success, offices: _allOffices));
  }

  Future<void> _onLoadUnavailableOffices(
    LoadUnavailableOffices event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      if (_allOffices.isEmpty) {
        _allOffices = await officeService.getAllOffices();
      }

      final unavailable = _allOffices
          .where((office) => office.available == false)
          .toList();

      emit(
        state.copyWith(
          status: Status.success,
          offices: unavailable,
          errorMessage: unavailable.isEmpty
              ? 'No hay oficinas ocupadas o no disponibles'
              : null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}
