import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:workstation_flutter/auth/domain/user_login.dart';
import 'package:workstation_flutter/auth/domain/user_register.dart';
import 'package:workstation_flutter/core/constants/api_constants.dart';
import 'package:workstation_flutter/core/storage/token_storage.dart';

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
      final decoded = jsonDecode(response.body);
      
      if (decoded is String) {
        await TokenStorage().save(decoded);
        
        return UserLogin.fromToken(decoded);
      }
      
      
      throw Exception('Formato de respuesta inesperado');
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

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final body = response.body;

        if (body.startsWith('"') && body.endsWith('"')) {
          final message = body.replaceAll('"', '');
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

        try {
          final json = jsonDecode(body);
          return UserRegister.fromJson(json);
        } catch (e) {
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
