import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:workstation_flutter/core/constants/api_constants.dart';
import 'package:workstation_flutter/features/profile/domain/user_response.dart';

class UserService {
  static const Duration _requestTimeout = Duration(seconds: 30);
  Future<UserResponse> getUserById(String id) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl).replace(
        path: WorkstationApiConstants.getUserById.replaceAll('{id}', id),
      );
      final http.Response response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(
            _requestTimeout,
            onTimeout: () {
              throw TimeoutException("demoro mucho, intenta nuevamente");
            },
          );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return UserResponse.fromJson(json);
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Usuario no encontrado');
      }

      throw HttpException(
        'Error al obtener usuario: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al obtener usuario: $e');
    }
  }
}
