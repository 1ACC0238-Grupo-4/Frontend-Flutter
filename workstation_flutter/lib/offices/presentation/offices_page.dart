import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/offices/presentation/widgets/office_card.dart';
import 'package:workstation_flutter/search/presentation/blocs/search_bloc.dart';
import 'package:workstation_flutter/search/presentation/blocs/search_event.dart';
import 'package:workstation_flutter/search/presentation/blocs/search_state.dart';

class OfficesPage extends StatefulWidget {
  const OfficesPage({super.key});

  @override
  State<OfficesPage> createState() => _OfficesPageState();
}

class _OfficesPageState extends State<OfficesPage> {
  @override
  void initState() {
    super.initState();
  context.read<SearchBloc>().add(LoadUnavailableOffices());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
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

          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                // Loading
                if (state.status == Status.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Error
                if (state.status == Status.failure) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Error desconocido',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                // Vacío
                if (state.offices.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay oficinas disponibles',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // Mostrar oficinas reales
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.offices.length,
                  itemBuilder: (context, index) {
                    final office = state.offices[index];

                    return OfficeCard(
                      office: office,
                      onTap: () {
                        print('Tapped: ${office.location}');
                        // Puedes navegar al detalle si deseas
                      },
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
