class Office {
  final String id;
  final String location;
  final String? description;
  final String? imageUrl;
  final int capacity;
  final int costPerDay;
  final bool available;
  final List<OfficeService> services;

  Office({
    required this.id,
    required this.location,
    this.description,
    this.imageUrl,
    required this.capacity,
    required this.costPerDay,
    required this.available,
    required this.services,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'],
      location: json['location'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      capacity: json['capacity'] ?? 0,
      costPerDay: json['costPerDay'] ?? 0,
      available: json['available'] ?? false,
      services: _parseServices(json['services']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'capacity': capacity,
      'costPerDay': costPerDay,
      'available': available,
      'services': services.map((s) => s.toJson()).toList(),
    };
  }

  static List<OfficeService> _parseServices(dynamic servicesJson) {
    if (servicesJson == null) return [];

    if (servicesJson is List) {
      return servicesJson
          .map((service) => OfficeService.fromJson(service))
          .toList();
    }

    return [];
  }
}

class OfficeService {
  final String name;
  final String description;
  final int cost;

  OfficeService({
    required this.name,
    required this.description,
    required this.cost,
  });

  factory OfficeService.fromJson(Map<String, dynamic> json) {
    return OfficeService(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      cost: json['cost'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'cost': cost,
    };
  }
}