import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/core/storage/auth_repository.dart';
import 'package:workstation_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:workstation_flutter/features/contract/domain/clause.dart';
import 'package:workstation_flutter/features/contract/domain/contract.dart';
import 'package:workstation_flutter/features/contract/domain/signature.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_bloc.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_event.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_state.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:workstation_flutter/features/search/presentation/blocs/search_bloc.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_event.dart';

class CreateContractPage extends StatefulWidget {
  final String officeId;
  final String officeName;
  final int officeCost;

  const CreateContractPage({
    Key? key,
    required this.officeId,
    required this.officeName,
    required this.officeCost,
  }) : super(key: key);

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();
  final TextEditingController _clauseNameController = TextEditingController();
  final TextEditingController _clauseContentController =
      TextEditingController();
  int _clauseOrder = 1;
  bool _clauseMandatory = false;

  DateTimeRange? _selectedDateRange;
  List<ClauseItem> _clauses = [];

  String? _userId;
  String? _createdContractId;
  bool _isContractCreated = false;
  bool _isActivatingContract = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final authRepo = context.read<AuthRepository>();
      final userId = await authRepo.getUserId();
      setState(() {
        _userId = userId;
      });
    } catch (e) {
      _showError('Error al obtener información del usuario');
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF8BC34A),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _addClause() {
    if (_clauseNameController.text.trim().isEmpty ||
        _clauseContentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos de la cláusula'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _clauses.add(
        ClauseItem(
          name: _clauseNameController.text.trim(),
          content: _clauseContentController.text.trim(),
          order: _clauseOrder,
          mandatory: _clauseMandatory,
        ),
      );
      _clauseNameController.clear();
      _clauseContentController.clear();
      _clauseOrder++;
      _clauseMandatory = false;
    });
  }

  void _removeClause(int index) {
    setState(() {
      _clauses.removeAt(index);
      for (int i = 0; i < _clauses.length; i++) {
        _clauses[i] = _clauses[i].copyWith(order: i + 1);
      }
      _clauseOrder = _clauses.length + 1;
    });
  }

  bool _validateForm() {
    if (_descriptionController.text.trim().isEmpty) {
      _showError('Por favor ingrese una descripción');
      return false;
    }
    if (_selectedDateRange == null) {
      _showError('Por favor seleccione las fechas del contrato');
      return false;
    }
    if (_signatureController.text.trim().isEmpty) {
      _showError('Por favor ingrese su firma');
      return false;
    }
    if (_userId == null) {
      _showError('Error al obtener el ID de usuario');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveContract() async {
    if (!_validateForm()) return;

    final contractBloc = context.read<ContractBloc>();

    final contractRequest = Contract(
      officeId: widget.officeId,
      ownerId: '4fd4973a-a0f2-42a7-a571-21565dfe614c',
      renterId: _userId!,
      description: _descriptionController.text.trim(),
      startDate: _selectedDateRange!.start,
      endDate: _selectedDateRange!.end,
      baseAmount: widget.officeCost,
      lateFee: 100,
      interestRate: 1.5,
    );

    contractBloc.add(SubmitCreateContract(contract: contractRequest));
  }

  Future<void> _addClausesToContract(String contractId) async {
    final contractBloc = context.read<ContractBloc>();
    for (var i = 0; i < _clauses.length; i++) {
      var clause = _clauses[i];
      final clauseRequest = Clause(
        name: clause.name,
        content: clause.content,
        order: clause.order,
        mandatory: clause.mandatory,
      );

      contractBloc.add(
        AddClauseToContract(contractId: contractId, clause: clauseRequest),
      );
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _addSignatureToContract(String contractId) async {
    final contractBloc = context.read<ContractBloc>();

    final signatureText = _signatureController.text.trim();

    if (signatureText.isEmpty) {
      _showError('La firma no puede estar vacía');
      return;
    }

    if (_userId == null || _userId!.isEmpty) {
      _showError('Error: Usuario no identificado');
      return;
    }
    final signatureRequest = Signature(
      signerId: _userId!,
      signatureHash: signatureText,
    );
    contractBloc.add(
      AddSignatureToContract(
        contractId: contractId,
        signature: signatureRequest,
      ),
    );
  }

  Future<void> _activateContract(String contractId) async {
    if (_isActivatingContract) return;

    setState(() {
      _isActivatingContract = true;
    });

    final contractBloc = context.read<ContractBloc>();
    contractBloc.add(ActivateContract(contractId: contractId));
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: BlocConsumer<ContractBloc, ContractState>(
      listener: (context, state) async {
        // BLOQUE 1: Crear contrato
        if (state.status == Status.success &&
            state.selectedContract != null) {
          if (!_isContractCreated) {
            _createdContractId = state.selectedContract!.id;
            _isContractCreated = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contrato creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            if (_clauses.isNotEmpty) {
              await _addClausesToContract(_createdContractId!);
              await Future.delayed(const Duration(milliseconds: 500));
            }
            await _addSignatureToContract(_createdContractId!);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Cláusulas y firma agregadas. Puede activar el contrato.',
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } // <--- CIERRA AQUÍ el if de crear contrato

        // BLOQUE 2: Error al activar (falta firma)
        if (state.status == Status.failure && _isActivatingContract) {
          setState(() {
            _isActivatingContract = false;
          });

          if (state.errorMessage != null &&
              (state.errorMessage!.contains('Ambas firmas son necesarias') ||
                  state.errorMessage!.contains('firmas'))) {
            _showInfo(
              '⏳ Propietario aún no ha firmado. '
              'El contrato se activará cuando ambas partes hayan firmado.',
            );
          } else {
            _showError('Error al activar contrato: ${state.errorMessage}');
          }
        }
        if (state.hasAllSignatures == Status.success &&
            _isActivatingContract) {
          _showSuccess('¡Contrato activado exitosamente!');
          
          final searchBloc = context.read<SearchBloc>();
          searchBloc.add(
            UpdateOfficeAvailability(
              officeId: widget.officeId,
              available: false,
            ),
          );

          await Future.delayed(const Duration(seconds: 1));

          if (!mounted) return;

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashPage()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: Container(
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
                              _buildDescriptionField(),
                              const SizedBox(height: 24),
                              _buildDateSelector(context),
                              const SizedBox(height: 24),
                              _buildClausesSection(),
                              const SizedBox(height: 24),
                              _buildSignatureField(),
                              const SizedBox(height: 32),
                              _buildActionButtons(state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.status == Status.loading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF8BC34A)),
                ),
              ),
          ],
        );
      },
    ),
  );
}

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.white24,
              child: const Icon(Icons.business, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.officeName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'S/. ${widget.officeCost.toStringAsFixed(2)} / mes',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F4C3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Ingrese una descripción del contrato',
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seleccione la fecha',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDateRange(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4C3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.black54),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedDateRange == null
                            ? 'Toque aquí para seleccionar fechas'
                            : 'Inicio: ${_formatDate(_selectedDateRange!.start)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedDateRange == null
                              ? Colors.black45
                              : Colors.black87,
                          fontWeight: _selectedDateRange == null
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedDateRange != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.event, color: Colors.black54),
                      const SizedBox(width: 12),
                      Text(
                        'Fin: ${_formatDate(_selectedDateRange!.end)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.black54),
                      const SizedBox(width: 12),
                      Text(
                        'Duración: ${_selectedDateRange!.duration.inDays} días',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildClausesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cláusulas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildClauseInputFields(),
        const SizedBox(height: 16),
        if (_clauses.isNotEmpty) _buildClausesList(),
      ],
    );
  }

  Widget _buildClauseInputFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Nombre:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _clauseNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0F4C3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: 'Ej: Pago mensual',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Contenido:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _clauseContentController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0F4C3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: 'Descripción de la cláusula',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Orden:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_clauseOrder > 1) {
                          setState(() => _clauseOrder--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: const Color(0xFF8BC34A),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4C3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _clauseOrder.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _clauseOrder++);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: const Color(0xFF8BC34A),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Obligatorio? (Sí/No)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Checkbox(
                      value: _clauseMandatory,
                      onChanged: (value) {
                        setState(() => _clauseMandatory = value ?? false);
                      },
                      activeColor: const Color(0xFF8BC34A),
                    ),
                    Text(_clauseMandatory ? 'Sí' : 'No'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _addClause,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Añadir',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: _addClause,
                  icon: const Icon(Icons.add, size: 28),
                  color: const Color(0xFF8BC34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClausesList() {
    return Column(
      children: _clauses.asMap().entries.map((entry) {
        int index = entry.key;
        ClauseItem clause = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF8BC34A).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cláusula: ${clause.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(clause.content, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      'Orden: ${clause.order} | ${clause.mandatory ? "Obligatoria" : "Opcional"}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _removeClause(index),
                icon: const Icon(Icons.remove_circle),
                color: Colors.red[700],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSignatureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Firma (Min. 8 letras)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _signatureController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Su firma',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ContractState state) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.status == Status.loading || _isContractCreated
                ? null
                : _saveContract,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0F4C3),
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: const Text(
              'Guardar Contrato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancelar operación',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    state.status == Status.loading ||
                        !_isContractCreated ||
                        _createdContractId == null ||
                        _isActivatingContract
                    ? null
                    : () => _activateContract(_createdContractId!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F4C3),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Text(
                  'Activar contrato',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _signatureController.dispose();
    _clauseNameController.dispose();
    _clauseContentController.dispose();
    super.dispose();
  }
}

class ClauseItem {
  final String name;
  final String content;
  final int order;
  final bool mandatory;

  ClauseItem({
    required this.name,
    required this.content,
    required this.order,
    required this.mandatory,
  });

  ClauseItem copyWith({
    String? name,
    String? content,
    int? order,
    bool? mandatory,
  }) {
    return ClauseItem(
      name: name ?? this.name,
      content: content ?? this.content,
      order: order ?? this.order,
      mandatory: mandatory ?? this.mandatory,
    );
  }
}
