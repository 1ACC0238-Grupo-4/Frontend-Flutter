import 'package:flutter/material.dart';
import 'package:workstation_flutter/features/contract/presentation/page/contract_page.dart';
import 'package:workstation_flutter/features/offices/domain/office.dart';

class OfficeDetailPage extends StatelessWidget {
  final Office office;
  final bool isReserved;
  final String userId;


  const OfficeDetailPage({
    super.key,
    required this.office,
    this.isReserved = false,
    required this.userId
    
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF8BC34A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'office_${office.id}',
                child: office.imageUrl != null
                    ? Image.network(
                        office.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isReserved)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8BC34A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Reservada',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isReserved) const SizedBox(height: 16),
                  Text(
                    office.location,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (office.description != null)
                    Text(
                      office.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.people,
                          title: 'Capacidad',
                          value: '${office.capacity} personas',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.attach_money,
                          title: 'Precio',
                          value: 'S/ ${office.costPerDay}/día',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),                  
                  if (!isReserved)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: office.available
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: office.available ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            office.available
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: office.available ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            office.available ? 'Disponible' : 'No disponible',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: office.available ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!isReserved) const SizedBox(height: 24),
                  
                  if (isReserved) ...[
                    _buildReservationInfo(),
                    const SizedBox(height: 24),
                  ],                  
                  const Text(
                    'Servicios incluidos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: office.services.map((service) {
                      return _buildServiceChip(service);
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  if (isReserved)
                    _buildReservedButtons(context)
                  else
                    _buildAvailableButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F48C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8BC34A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: Colors.black87),
              SizedBox(width: 8),
              Text(
                'Información de reserva',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Fecha de inicio:', '01/12/2024'),
          const SizedBox(height: 8),
          _buildInfoRow('Fecha de fin:', '31/12/2024'),
          const SizedBox(height: 8),
          _buildInfoRow('Estado:', 'Activa'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildReservedButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Abrir contrato PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Abriendo contrato...'),
                ),
              );
            },
            icon: const Icon(Icons.description),
            label: const Text(
              'Ver contrato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Navegar a chat con el dueño
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contactando al propietario...'),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text(
              'Contactar propietario',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF689F38),
              side: const BorderSide(color: Color(0xFF689F38), width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableButtons(BuildContext context) {
  // Asumiendo que 'office' es un objeto que tiene una propiedad 'id' y 'available'
  final officeId = office.id; 

  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: office.available
              ? () {
                  // ✅ IMPLEMENTACIÓN DE NAVEGACIÓN A CONTRACTSPAGE
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateContractPage(officeId: office.id, officeName: office.location, officeCost: office.costPerDay),
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.event_available),
          label: const Text(
            'Reservar ahora',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8BC34A),
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            disabledBackgroundColor: Colors.grey,
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: office.available
              ? () {
                  // TODO: Navegar a chat con el dueño
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Abriendo chat...'),
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.message),
          label: const Text(
            'Mensaje al propietario',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF689F38),
            side: const BorderSide(color: Color(0xFF689F38), width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F48C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(OfficeService service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.business,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }
}