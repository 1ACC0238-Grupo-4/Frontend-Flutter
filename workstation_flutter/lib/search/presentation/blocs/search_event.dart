abstract class SearchEvent {
  const SearchEvent();
}

/// Evento para cargar todas las oficinas
class LoadAllOffices extends SearchEvent {
  const LoadAllOffices();
}

/// Evento para buscar oficinas por ubicación
class SearchOfficesByLocation extends SearchEvent {
  const SearchOfficesByLocation();
}

/// Evento cuando cambia el ID de ubicación
class OnLocationIdChanged extends SearchEvent {
  final String locationId;
  const OnLocationIdChanged({required this.locationId});
}

/// Evento para filtrar oficinas disponibles
class FilterAvailableOffices extends SearchEvent {
  const FilterAvailableOffices();
}

/// Evento cuando cambia la capacidad mínima
class OnMinCapacityChanged extends SearchEvent {
  final int minCapacity;
  const OnMinCapacityChanged({required this.minCapacity});
}

/// Evento cuando cambia el precio mínimo
class OnMinPriceChanged extends SearchEvent {
  final int minPrice;
  const OnMinPriceChanged({required this.minPrice});
}

/// Evento cuando cambia el precio máximo
class OnMaxPriceChanged extends SearchEvent {
  final int maxPrice;
  const OnMaxPriceChanged({required this.maxPrice});
}

/// Evento cuando cambia el filtro de disponibilidad
class OnAvailabilityChanged extends SearchEvent {
  final bool onlyAvailable;
  const OnAvailabilityChanged({required this.onlyAvailable});
}

/// Evento para aplicar todos los filtros
class ApplyFilters extends SearchEvent {
  const ApplyFilters();
}

/// Evento para obtener una oficina específica por ID
class GetOfficeById extends SearchEvent {
  final String officeId;
  const GetOfficeById({required this.officeId});
}

/// Evento para resetear la búsqueda
class ResetSearch extends SearchEvent {
  const ResetSearch();
}

class LoadUnavailableOffices extends SearchEvent {
  const LoadUnavailableOffices();
}
