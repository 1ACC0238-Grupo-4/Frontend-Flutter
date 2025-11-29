abstract class SearchEvent {
  const SearchEvent();
}

class LoadAllOffices extends SearchEvent {
  const LoadAllOffices();
}

class SearchOfficesByLocation extends SearchEvent {
  const SearchOfficesByLocation();
}

class OnLocationIdChanged extends SearchEvent {
  final String locationId;
  const OnLocationIdChanged({required this.locationId});
}

class FilterAvailableOffices extends SearchEvent {
  const FilterAvailableOffices();
}

class OnMinCapacityChanged extends SearchEvent {
  final int minCapacity;
  const OnMinCapacityChanged({required this.minCapacity});
}

class OnMinPriceChanged extends SearchEvent {
  final int minPrice;
  const OnMinPriceChanged({required this.minPrice});
}

class OnMaxPriceChanged extends SearchEvent {
  final int maxPrice;
  const OnMaxPriceChanged({required this.maxPrice});
}

class OnAvailabilityChanged extends SearchEvent {
  final bool onlyAvailable;
  const OnAvailabilityChanged({required this.onlyAvailable});
}

class ApplyFilters extends SearchEvent {
  const ApplyFilters();
}

class GetOfficeById extends SearchEvent {
  final String officeId;
  const GetOfficeById({required this.officeId});
}

class ResetSearch extends SearchEvent {
  const ResetSearch();
}

class LoadUnavailableOffices extends SearchEvent {
  const LoadUnavailableOffices();
  
}

