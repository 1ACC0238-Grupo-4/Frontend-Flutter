import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:workstation_flutter/core/constants/api_constants.dart';
import 'package:workstation_flutter/features/contract/domain/clause.dart';
import 'package:workstation_flutter/features/contract/domain/contract.dart';
import 'package:workstation_flutter/features/contract/domain/response/contract_response.dart';
import 'package:workstation_flutter/features/contract/domain/signature.dart';

class ContractAPIService {
  static const Duration _requestTimeout = Duration(seconds: 30);
  Future<ContractResponse> createContract(Contract contract) async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(path: WorkstationApiConstants.createContractEndpoint);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contract.toJson()),
      );

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        return ContractResponse.fromJson(jsonDecode(response.body));
      }
      throw HttpException(
        'Error al crear contrato: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al crear contrato: $e');
    }
  }

  Future<ContractResponse> addClauseToContract(
    String contractId,
    Clause clause,
  ) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.addClauseEndpoint.replaceAll(
          "{contractId}",
          contractId,
        ),
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clause.toJson()),
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return ContractResponse.fromJson(jsonDecode(response.body));
      }
      throw HttpException(
        'Error al agregar cláusula: ${response.statusCode}, ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<ContractResponse> addSignatureToContract(
    String contractId,
    Signature signature,
  ) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.addSignatureEndpoint.replaceAll(
          "{contractId}",
          contractId,
        ),
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signature.toJson()),
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return ContractResponse.fromJson(jsonDecode(response.body));
      }
      throw HttpException(
        'Error al agregar firma: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al agregar firma: $e');
    }
  }

  Future<void> activateContract(String contractId) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.activateContractEndpoint.replaceAll(
          "{contractId}",
          contractId,
        ),
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        return;
      }

      throw HttpException(
        'Error al activar contrato: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al activar contrato: $e');
    }
  }

  Future<List<ContractResponse>> getContractsByUser(String userId) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.getContractEnpoint.replaceAll(
          '{userId}',
          userId,
        ),
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => ContractResponse.fromJson(json)).toList();
      }
      throw HttpException(
        'Error al obtener contratos: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al obtener contratos: $e');
    }
  }

  Future<List<ContractResponse>> getAllActiveContracts() async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(path: WorkstationApiConstants.getAllActiveContractsEndpoint);

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(
            _requestTimeout,
            onTimeout: () {
              throw TimeoutException(
                "La solicitud demoro demasiado, porfavor intenta nuevamente.",
              );
            },
          );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final contracts = jsonList
            .map((json) => ContractResponse.fromJson(json))
            .toList();

        return contracts;
      }

      throw HttpException(
        'Error al obtener contratos activos: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al obtener contratos activos: $e');
    }
  }
}
