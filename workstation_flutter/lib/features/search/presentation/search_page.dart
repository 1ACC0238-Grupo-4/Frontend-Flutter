import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/core/storage/auth_repository.dart';
import 'package:workstation_flutter/features/offices/domain/office.dart';
import 'package:workstation_flutter/features/offices/presentation/office_detail_page.dart';
import 'package:workstation_flutter/features/offices/presentation/widgets/office_card.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_bloc.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_event.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _capacityRange = const RangeValues(1, 50);
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _onlyAvailable = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<SearchBloc>().add(FilterAvailableOffices());
  }

  Future<void> _loadUserId() async {
    final repo = context.read<AuthRepository>();
    final userId = await repo.getUserId();

    setState(() => _userId = userId);
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
                    CheckboxListTile(
                      title: const Text('Solo oficinas disponibles'),
                      value: _onlyAvailable,
                      onChanged: (bool? value) {
                        setDialogState(() {
                          _onlyAvailable = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Capacidad mínima',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _capacityRange.start,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: _capacityRange.start.round().toString(),
                      onChanged: (double value) {
                        setDialogState(() {
                          _capacityRange = RangeValues(
                            value,
                            _capacityRange.end,
                          );
                        });
                      },
                    ),
                    Text(
                      'Mínimo: ${_capacityRange.start.round()} personas',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Rango de precio (por día)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels(
                        'S/ ${_priceRange.start.round()}',
                        'S/ ${_priceRange.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setDialogState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                    Text(
                      'De S/ ${_priceRange.start.round()} a S/ ${_priceRange.end.round()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _capacityRange = const RangeValues(1, 50);
                      _priceRange = const RangeValues(0, 1000);
                      _onlyAvailable = false;
                    });
                    context.read<SearchBloc>().add(ResetSearch());
                  },
                  child: const Text('Limpiar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final bloc = context.read<SearchBloc>();

                    bloc.add(
                      OnMinCapacityChanged(
                        minCapacity: _capacityRange.start.round(),
                      ),
                    );

                    bloc.add(
                      OnMinPriceChanged(minPrice: _priceRange.start.round()),
                    );

                    bloc.add(
                      OnMaxPriceChanged(maxPrice: _priceRange.end.round()),
                    );

                    bloc.add(
                      OnAvailabilityChanged(onlyAvailable: _onlyAvailable),
                    );

                    bloc.add(ApplyFilters());

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

  void _searchByLocation() {
    final location = _searchController.text.trim();
    if (location.isNotEmpty) {
      context.read<SearchBloc>()
        ..add(OnLocationIdChanged(locationId: location))
        ..add(SearchOfficesByLocation());
    }
  }

  void _navigateToOfficeDetail(Office office) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<SearchBloc>(),
          child: OfficeDetailPage(
            office: office,
            isReserved: false,
            userId: _userId!,
          ),
        ),
      ),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchByLocation(),
              decoration: InputDecoration(
                hintText: 'Busca tu oficina por ubicación',
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
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black87),
                      onPressed: _searchByLocation,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black87,
                      ),
                      onPressed: _showFilterDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

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

          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF8BC34A)),
                  );
                }

                if (state.status == Status.failure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            state.errorMessage ?? 'Error al cargar oficinas',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SearchBloc>().add(LoadAllOffices());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            foregroundColor: Colors.black87,
                          ),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.offices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            state.errorMessage ?? 'No se encontraron oficinas',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<SearchBloc>().add(ResetSearch());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            foregroundColor: Colors.black87,
                          ),
                          child: const Text('Limpiar filtros'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: state.offices.length,
                  itemBuilder: (context, index) {
                    return OfficeCard(
                      office: state.offices[index],
                      showButton: true,
                      isReserved: false,
                      userId: _userId ?? "",
                      onTap: () =>
                          _navigateToOfficeDetail(state.offices[index]),
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
