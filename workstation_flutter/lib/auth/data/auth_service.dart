import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:workstation_flutter/auth/domain/user_login.dart';
import 'package:workstation_flutter/auth/domain/user_register.dart';
import 'package:workstation_flutter/core/constants/api_constants.dart';

class AuthService {
  Future<UserLogin> login(String email, String password) async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(path: WorkstationApiConstants.loginEndpoint);

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'passwordHash': password}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final body = response.body;

        if (body.startsWith('"') && body.endsWith('"')) {
          final token = body.replaceAll('"', '');
          return UserLogin(token: token);
        }

        final json = jsonDecode(body);
        return UserLogin.fromJson(json);
      }

      throw HttpException('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      throw Exception('Unexpected error while fetching data: $e');
    }
  }

  Future<UserRegister> register(
    String firstName,
    String lastName,
    String dni,
    String phoneNumber,
    String email,
    String password,
    int role,
  ) async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(path: WorkstationApiConstants.registerEndpoint);

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'dni': dni,
          'phoneNumber': phoneNumber,
          'email': email,
          'passwordHash': password,
          'role': role,
        }),
      );

      print('Register Status Code: ${response.statusCode}');
      print('Register Response Body: ${response.body}');
      print('Register Response Type: ${response.body.runtimeType}');

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final body = response.body;

        // ✅ Manejo similar al login: verificar si es un string simple
        if (body.startsWith('"') && body.endsWith('"')) {
          // El backend devuelve un string (probablemente un mensaje o token)
          final message = body.replaceAll('"', '');
          // Crear un UserRegister con datos del registro exitoso
          return UserRegister(
            firstName: firstName,
            lastName: lastName,
            dni: dni,
            phoneNumber: phoneNumber,
            email: email,
            password: password,
            role: role,
          );
        }

        // Si es un JSON válido, parsearlo
        try {
          final json = jsonDecode(body);
          return UserRegister.fromJson(json);
        } catch (e) {
          // Si falla el parseo pero el registro fue exitoso (200/201)
          print('No se pudo parsear JSON, pero registro exitoso: $e');
          return UserRegister(
            firstName: firstName,
            lastName: lastName,
            dni: dni,
            phoneNumber: phoneNumber,
            email: email,
            password: password,
            role: role,
          );
        }
      }

      // Manejo de errores más específico
      if (response.statusCode == HttpStatus.badRequest) {
        final errorBody = response.body;
        throw HttpException('Bad Request (400): $errorBody');
      }

      if (response.statusCode == HttpStatus.conflict) {
        throw HttpException('Conflict (409): El usuario ya existe');
      }

      throw HttpException(
        'Unexpected status code: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Unexpected error while fetching data: $e');
    }
  }
}
