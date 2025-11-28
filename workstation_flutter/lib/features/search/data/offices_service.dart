import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:workstation_flutter/core/constants/api_constants.dart';
import 'package:workstation_flutter/features/offices/domain/office.dart';

class OfficeAPIService {
  Future<List<Office>> getAllOffices() async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(path: WorkstationApiConstants.officesEndpoint);

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Office.fromJson(json)).toList();
      }

      throw HttpException(
        'Error al obtener oficinas: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al obtener oficinas: $e');
    }
  }

  Future<Office> getOfficeById(String id) async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(
        path: WorkstationApiConstants.officeByIdEndpoint.replaceAll('{id}', id),
      );

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Office.fromJson(json);
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Oficina no encontrada');
      }

      throw HttpException(
        'Error al obtener oficina: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al obtener oficina: $e');
    }
  }

  Future<List<Office>> getOfficesByLocation(String locationId) async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(
        path: WorkstationApiConstants.officeByLocationEndpoint
            .replaceAll('{id}', locationId),
      );

      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Office.fromJson(json)).toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('No se encontraron oficinas en esta ubicación');
      }

      throw HttpException(
        'Error al obtener oficinas por ubicación: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al obtener oficinas por ubicación: $e');
    }
  }

  Future<List<Office>> getAvailableOffices() async {
    try {
      final offices = await getAllOffices();
      return offices.where((office) => office.available).toList();
    } catch (e) {
      throw Exception('Error al obtener oficinas disponibles: $e');
    }
  }

  Future<List<Office>> getOfficesByCapacity(int minCapacity) async {
    try {
      final offices = await getAllOffices();
      return offices.where((office) => office.capacity >= minCapacity).toList();
    } catch (e) {
      throw Exception('Error al filtrar oficinas por capacidad: $e');
    }
  }

  Future<List<Office>> getOfficesByPriceRange(int minPrice, int maxPrice) async {
    try {
      final offices = await getAllOffices();
      return offices
          .where((office) =>
              office.costPerDay >= minPrice && office.costPerDay <= maxPrice)
          .toList();
    } catch (e) {
      throw Exception('Error al filtrar oficinas por precio: $e');
    }
  }
  Future<Office> updateOfficeAvailability(Office office, bool available) async {
    try {
      final Uri uri = Uri.parse(
        WorkstationApiConstants.baseUrl,
      ).replace(
        path: WorkstationApiConstants.updateOfficeByIdEndpoint.replaceAll('{id}', office.id),
      );

      final Map<String, dynamic> requestBody = {
        'id': office.id,
        'location': office.location,
        'description': office.description,
        'imageUrl': office.imageUrl,
        'capacity': office.capacity,
        'costPerDay': office.costPerDay,
        'available': available,
      };

      final http.Response response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Office.fromJson(json);
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Oficina no encontrada');
      }

      throw HttpException(
        'Error al actualizar oficina: ${response.statusCode}, Body: ${response.body}',
      );
    } catch (e) {
      throw Exception('Error inesperado al actualizar disponibilidad de oficina: $e');
    }
  }
} 