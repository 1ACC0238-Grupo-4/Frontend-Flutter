import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:workstation_flutter/core/constants/api_constants.dart';
import 'package:workstation_flutter/features/contract/domain/clause.dart';
import 'package:workstation_flutter/features/contract/domain/contract.dart';
import 'package:workstation_flutter/features/contract/domain/response/contract_response.dart';
import 'package:workstation_flutter/features/contract/domain/signature.dart';

class ContractAPIService {

  Future<ContractResponse> createContract(Contract contract) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl)
          .replace(path: WorkstationApiConstants.createContractEndpoint);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(contract.toJson()),
      );

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        return ContractResponse.fromJson(jsonDecode(response.body));
      }

      // LOG DEL ERROR ANTES DE LANZAR
      print("❌ ERROR createContract -> "
            "Status: ${response.statusCode}, Body: ${response.body}");

      throw HttpException(
        'Error al crear contrato: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      print("🔥 EXCEPCIÓN createContract -> $e");
      throw Exception('Error inesperado al crear contrato: $e');
    }
  }

  Future<ContractResponse> addClauseToContract(String contractId, Clause clause) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.addClauseEndpoint
            .replaceAll("{contractId}", contractId),
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

      print("❌ ERROR addClauseToContract -> "
            "Status: ${response.statusCode}, Body: ${response.body}");

      throw HttpException(
          'Error al agregar cláusula: ${response.statusCode}, ${response.body}');
    } catch (e) {
      print("🔥 EXCEPCIÓN addClauseToContract -> $e");
      throw Exception('Error inesperado: $e');
    }
  }

  Future<ContractResponse> addSignatureToContract(
      String contractId, Signature signature) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.addSignatureEndpoint
            .replaceAll("{contractId}", contractId),
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

      print("❌ ERROR addSignatureToContract -> "
            "Status: ${response.statusCode}, Body: ${response.body}");

      throw HttpException(
        'Error al agregar firma: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      print("🔥 EXCEPCIÓN addSignatureToContract -> $e");
      throw Exception('Error inesperado al agregar firma: $e');
    }
  }

  Future<void> activateContract(String contractId) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.activateContractEndpoint
            .replaceAll("{contractId}", contractId),
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        return;
      }

      print("❌ ERROR activateContract -> "
            "Status: ${response.statusCode}, Body: ${response.body}");

      throw HttpException(
        'Error al activar contrato: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      print("🔥 EXCEPCIÓN activateContract -> $e");
      throw Exception('Error inesperado al activar contrato: $e');
    }
  }

  Future<List<ContractResponse>> getContractsByUser(String userId) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.getContractEnpoint
            .replaceAll('{userId}', userId),
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => ContractResponse.fromJson(json))
            .toList();
      }

      print("❌ ERROR getContractsByUser -> "
            "Status: ${response.statusCode}, Body: ${response.body}");

      throw HttpException(
        'Error al obtener contratos: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      print("🔥 EXCEPCIÓN getContractsByUser -> $e");
      throw Exception('Error inesperado al obtener contratos: $e');
    }
  }
}
