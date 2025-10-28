class Office {
  final String? id;
  final String location;
  final String? description;
  final String? imageUrl;
  final int capacity;
  final int costPerDay;
  final bool available;
  final List<OfficeService> services;

  Office({
    this.id,
    required this.location,
    this.description,
    this.imageUrl,
    required this.capacity,
    required this.costPerDay,
    required this.available,
    required this.services,
  });
}

enum OfficeService {
  wifi,
  coffee,
  kitchen,
  airConditioning,
  projector,
  whiteboard,
  parking,
  printer,
}

extension OfficeServiceExtension on OfficeService {
  String get displayName {
    switch (this) {
      case OfficeService.wifi:
        return 'WiFi';
      case OfficeService.coffee:
        return 'Café';
      case OfficeService.kitchen:
        return 'Cocina';
      case OfficeService.airConditioning:
        return 'Aire Acondicionado';
      case OfficeService.projector:
        return 'Proyector';
      case OfficeService.whiteboard:
        return 'Pizarra';
      case OfficeService.parking:
        return 'Estacionamiento';
      case OfficeService.printer:
        return 'Impresora';
    }
  }
}