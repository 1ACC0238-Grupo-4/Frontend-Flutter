import 'package:flutter/material.dart';
import 'package:workstation_flutter/offices/domain/office.dart';
import 'package:workstation_flutter/offices/presentation/widgets/office_card.dart';

class OfficesPage extends StatefulWidget {
  const OfficesPage({super.key});

  @override
  State<OfficesPage> createState() => _OfficesPageState();
}

class _OfficesPageState extends State<OfficesPage> {

  final List<Office> _reservedOffices = [
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
  ];


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
                  'Reservas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            // Content area
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _reservedOffices.length,
                itemBuilder: (context, index) {
                  return OfficeCard(
                    office: _reservedOffices[index],
                    onTap: () {
                      // TODO: Navigate to office details
                      print(
                        'Tapped on office: ${_reservedOffices[index].location}',
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
