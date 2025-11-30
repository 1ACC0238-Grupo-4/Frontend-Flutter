import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_detail_bloc.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_detail_event.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_detail_state.dart';
import 'package:intl/intl.dart';

class ContractDetailPage extends StatefulWidget {
  final String officeId;

  const ContractDetailPage({
    Key? key,
    required this.officeId,
  }) : super(key: key);

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  @override
  void initState() {
    super.initState();
    // Cargar el contrato cuando se inicializa la página
    context.read<ContractDetailBloc>().add(
          LoadContractByOfficeId(officeId: widget.officeId),
        );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF8BC34A),
    body: SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: BlocBuilder<ContractDetailBloc, ContractDetailState>(
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state.status == Status.failure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Error al cargar el contrato',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage ?? 'Error desconocido',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // ✅ BOTÓN DE REINTENTAR
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<ContractDetailBloc>().add(
                                    LoadContractByOfficeId(officeId: widget.officeId),
                                  );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF8BC34A),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.contract == null) {
                  return const Center(
                    child: Text(
                      'No se encontró el contrato',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Información General'),
                        const SizedBox(height: 12),
                        _buildInfoCard(state),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('Ubicación'),
                        const SizedBox(height: 12),
                        _buildOfficeCard(state),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('Participantes'),
                        const SizedBox(height: 12),
                        _buildParticipantsCard(state),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('Detalles Económicos'),
                        const SizedBox(height: 12),
                        _buildEconomicCard(state),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('Cláusulas (${state.contract!.clauses.length})'),
                        const SizedBox(height: 12),
                        _buildClausesCard(state),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('Firmas (${state.contract!.signatures.length})'),
                        const SizedBox(height: 12),
                        _buildSignaturesCard(state),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const SplashPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Detalles del Contrato',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'ACTIVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8BC34A),
      ),
    );
  }

  Widget _buildInfoCard(ContractDetailState state) {
    final contract = state.contract!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.description,
            label: 'Descripción',
            value: contract.description,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Fecha de inicio',
            value: _formatDate(contract.startDate),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.event,
            label: 'Fecha de fin',
            value: _formatDate(contract.endDate),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Creado el',
            value: _formatDateTime(contract.createdAt),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.timelapse,
            label: 'Duración',
            value: '${contract.endDate.difference(contract.startDate).inDays} días',
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeCard(ContractDetailState state) {
    if (state.officeStatus == Status.loading) {
      return _buildLoadingCard();
    }

    if (state.office == null) {
      return _buildErrorCard('No se pudo cargar la información de la oficina');
    }

    final office = state.office!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (office.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                office.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 48),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Ubicación',
            value: office.location,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.people,
            label: 'Capacidad',
            value: '${office.capacity} personas',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.attach_money,
            label: 'Costo por día',
            value: 'S/. ${office.costPerDay.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsCard(ContractDetailState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Owner
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_center,
                  color: Color(0xFF8BC34A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Propietario',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (state.ownerStatus == Status.loading)
                      const Text('Cargando...')
                    else if (state.owner != null)
                      Text(
                        state.owner!.firstName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text('No disponible'),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          // Renter
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF8BC34A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Arrendatario',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (state.renterStatus == Status.loading)
                      const Text('Cargando...')
                    else if (state.renter != null)
                      Text(
                        state.renter!.firstName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text('No disponible'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEconomicCard(ContractDetailState state) {
    final contract = state.contract!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.payments,
            label: 'Monto base',
            value: 'S/. ${contract.baseAmount}',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.warning_amber,
            label: 'Cargo por mora',
            value: 'S/. ${contract.lateFee.toStringAsFixed(2)}',
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.percent,
            label: 'Tasa de interés',
            value: '${contract.interestRate.toStringAsFixed(2)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildClausesCard(ContractDetailState state) {
    final contract = state.contract!;

    if (contract.clauses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E99F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No hay cláusulas registradas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return Column(
      children: contract.clauses.map((clause) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD4E99F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: clause.mandatory
                          ? const Color(0xFF8BC34A)
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      clause.mandatory ? 'OBLIGATORIA' : 'OPCIONAL',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Orden ${clause.order}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                clause.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                clause.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSignaturesCard(ContractDetailState state) {
    final contract = state.contract!;

    if (contract.signatures.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E99F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No hay firmas registradas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return Column(
      children: contract.signatures.map((signature) {
        // Determinar si es el owner o el renter
        final isOwner = signature.signerId == contract.ownerId;
        final signerName = isOwner
            ? (state.owner?.firstName ?? 'Propietario')
            : (state.renter?.firstName ?? 'Arrendatario');

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD4E99F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isOwner ? Icons.business_center : Icons.person,
                  color: const Color(0xFF8BC34A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Firmado el ${_formatDateTime(signature.signedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.verified,
                color: Color(0xFF8BC34A),
                size: 24,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF8BC34A),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8BC34A),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}