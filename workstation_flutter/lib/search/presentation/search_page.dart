import 'package:flutter/material.dart';
import 'package:workstation_flutter/chats/presentation/chats_page.dart';
import 'package:workstation_flutter/home/presentation/home_page.dart';
import 'package:workstation_flutter/offices/domain/office.dart';
import 'package:workstation_flutter/offices/presentation/offices_page.dart';
import 'package:workstation_flutter/offices/presentation/widgets/office_card.dart';
import 'package:workstation_flutter/profile/presentation/profile_page.dart';
import 'package:workstation_flutter/shared/presentation/widgets/bottom_nav_bar_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _currentIndex = 2;
  final TextEditingController _searchController = TextEditingController();

  RangeValues _capacityRange = const RangeValues(1, 50);
  final Set<OfficeService> _selectedServices = {};

  final List<Office> _allOffices = [
    Office(
      id: '1',
      location: 'Oficina Ejecutiva - Miraflores',
      description: 'Oficina privada con vista al mar',
      imageUrl:
          'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
      capacity: 1,
      costPerDay: 150,
      available: true,
      services: [
        OfficeService.wifi,
        OfficeService.coffee,
        OfficeService.airConditioning,
      ],
    ),
    Office(
      id: '2',
      location: 'Sala de Reuniones - San Isidro',
      description: 'Espacio colaborativo moderno',
      imageUrl:
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=800',
      capacity: 8,
      costPerDay: 300,
      available: true,
      services: [
        OfficeService.wifi,
        OfficeService.projector,
        OfficeService.whiteboard,
      ],
    ),
    Office(
      id: '3',
      location: 'Sala Conferencias - Surco',
      description: 'Sala grande para presentaciones',
      imageUrl:
          'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800',
      capacity: 20,
      costPerDay: 500,
      available: true,
      services: [
        OfficeService.wifi,
        OfficeService.projector,
        OfficeService.airConditioning,
        OfficeService.coffee,
      ],
    ),
    Office(
      id: '4',
      location: 'Oficina Compartida - Barranco',
      description: 'Espacio de coworking creativo',
      imageUrl:
          'https://images.unsplash.com/photo-1497366412874-3415097a27e7?w=800',
      capacity: 15,
      costPerDay: 250,
      available: true,
      services: [
        OfficeService.wifi,
        OfficeService.kitchen,
        OfficeService.coffee,
      ],
    ),
    Office(
      id: '5',
      location: 'Oficina Premium - La Molina',
      description: 'Oficina de lujo totalmente equipada',
      imageUrl:
          'https://images.unsplash.com/photo-1497366858526-0766cadbe8fa?w=800',
      capacity: 4,
      costPerDay: 350,
      available: true,
      services: [
        OfficeService.wifi,
        OfficeService.coffee,
        OfficeService.airConditioning,
        OfficeService.printer,
      ],
    ),
    Office(
      id: '6',
      location: 'Coworking Space - Lince',
      description: 'Espacio abierto y luminoso',
      imageUrl:
          'https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=800',
      capacity: 30,
      costPerDay: 100,
      available: true,
      services: [
        OfficeService.wifi,
        OfficeService.kitchen,
        OfficeService.parking,
      ],
    ),
    Office(
      id: '7',
      location: 'Sala Ejecutiva - Jesús María',
      description: 'Sala de juntas elegante',
      imageUrl:
          'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
      capacity: 12,
      costPerDay: 400,
      available: true,
      services: [
        OfficeService.wifi,
        OfficeService.projector,
        OfficeService.whiteboard,
        OfficeService.coffee,
      ],
    ),
  ];

  List<Office> get _filteredOffices {
    return _allOffices.where((office) {
      // Filtro por capacidad
      if (office.capacity < _capacityRange.start ||
          office.capacity > _capacityRange.end) {
        return false;
      }

      // Filtro por servicios
      if (_selectedServices.isNotEmpty) {
        if (!_selectedServices.every(
          (service) => office.services.contains(service),
        )) {
          return false;
        }
      }

      // Filtro por búsqueda de texto
      if (_searchController.text.isNotEmpty) {
        return office.location.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            (office.description?.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ??
                false);
      }

      return true;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filtros'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rango de aforo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RangeSlider(
                      values: _capacityRange,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      labels: RangeLabels(
                        _capacityRange.start.round().toString(),
                        _capacityRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setDialogState(() {
                          _capacityRange = values;
                        });
                      },
                    ),
                    Text(
                      'De ${_capacityRange.start.round()} a ${_capacityRange.end.round()} personas',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Servicios',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...OfficeService.values.map((service) {
                      return CheckboxListTile(
                        title: Text(service.displayName),
                        value: _selectedServices.contains(service),
                        onChanged: (bool? value) {
                          setDialogState(() {
                            if (value == true) {
                              _selectedServices.add(service);
                            } else {
                              _selectedServices.remove(service);
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _capacityRange = const RangeValues(1, 50);
                      _selectedServices.clear();
                    });
                  },
                  child: const Text('Limpiar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Actualizar la lista principal
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            // Header with wave decoration
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF8BC34A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(200, 30),
                  bottomRight: Radius.elliptical(200, 30),
                ),
              ),
              child: const Center(
                child: Text(
                  'Búsqueda',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Busca tu oficina',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                  filled: true,
                  fillColor: const Color(0xFFE8F48C),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.black87),
                    onPressed: _showFilterDialog,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // "Oficinas recomendadas" header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Oficinas recomendadas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Office list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _filteredOffices.length,
                itemBuilder: (context, index) {
                  return OfficeCard(
                    office: _filteredOffices[index],
                    showButton: true,
                    onTap: () {
                      print(
                        'Tapped on office: ${_filteredOffices[index].location}',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}
