import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/features/offices/domain/office.dart';

class SearchState {
  final Status status;
  final List<Office> offices;
  final Office? selectedOffice;
  final String locationId;
  final int? minCapacity;
  final int? minPrice;
  final int? maxPrice;
  final bool onlyAvailable;
  final String? errorMessage;
  final Status updateStatus; // Estado específico para actualización

  const SearchState({
    this.status = Status.initial,
    this.offices = const [],
    this.selectedOffice,
    this.locationId = '',
    this.minCapacity,
    this.minPrice,
    this.maxPrice,
    this.onlyAvailable = false,
    this.errorMessage,
    this.updateStatus = Status.initial,
  });

  SearchState copyWith({
    Status? status,
    List<Office>? offices,
    Office? selectedOffice,
    String? locationId,
    int? minCapacity,
    int? minPrice,
    int? maxPrice,
    bool? onlyAvailable,
    String? errorMessage,
    Status? updateStatus,
  }) {
    return SearchState(
      status: status ?? this.status,
      offices: offices ?? this.offices,
      selectedOffice: selectedOffice ?? this.selectedOffice,
      locationId: locationId ?? this.locationId,
      minCapacity: minCapacity ?? this.minCapacity,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      errorMessage: errorMessage ?? this.errorMessage,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }
}