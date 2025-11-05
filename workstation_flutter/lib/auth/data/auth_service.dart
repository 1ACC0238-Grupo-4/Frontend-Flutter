import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:workstation_flutter/auth/domain/user_login.dart';
import 'package:workstation_flutter/auth/domain/user_register.dart';
import 'package:workstation_flutter/core/constants/api_constants.dart';

class AuthService {
  Future<UserLogin> login(String email, String password) async {
    try {
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl)
          .replace(path: WorkstationApiConstants.loginEndpoint);

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'passwordHash': password}),
      );

      if (response.statusCode == HttpStatus.ok) {
        final body = response.body;

        // Si la respuesta es un string plano (JWT), lo tratamos como tal
        if (body.startsWith('"') && body.endsWith('"')) {
          final token = body.replaceAll('"', '');
          return UserLogin(token: token);
        }

        // Si la respuesta es un JSON, la decodificamos normalmente
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
      final Uri uri = Uri.parse(WorkstationApiConstants.baseUrl)
          .replace(path: WorkstationApiConstants.registerEndpoint);

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'dni': dni,
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return UserRegister.fromJson(json);
      }

      throw HttpException('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      throw Exception('Unexpected error while fetching data: $e');
    }
  }
}
