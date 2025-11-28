import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:workstation_flutter/core/storage/token_storage.dart';

class AuthRepository {
  final TokenStorage tokenStorage;

  AuthRepository(this.tokenStorage);

  Future<String?> getToken() async {
    return await tokenStorage.read();
  }

  Future<String?> getUserId() async {
    final token = await tokenStorage.read();
    if (token == null) return null;

    final payload = JwtDecoder.decode(token);
    return payload["nameid"]; 
  }
}
