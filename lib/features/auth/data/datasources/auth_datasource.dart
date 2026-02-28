import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/app_exports.dart';

class AuthDataSource {
  final Dio dio;

  AuthDataSource({required this.dio});

  Future<AuthModel> postAuth(
    String login,
    String clave,
    String plataforma,
  ) async {
    try {
      final sistemaID = int.parse(dotenv.env['SISTEMA_ID'] ?? '0');
      final vip = dotenv.env['VIP'] ?? '';

      final response = await dio.post(
        '/api/ext/login',
        data: {
          'login': login,
          'clave': clave,
          'SISTEMA_ID': sistemaID,
          'VIP': vip,
          'VSO': plataforma,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(milliseconds: 30000),
          receiveTimeout: Duration(milliseconds: 30000),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (data == null) {
          throw Exception('Respuesta vacía del servidor');
        }

        // Validar código de respuesta
        final vCod = data['vCod'];
        if (vCod != '200') {
          throw Exception(data['vDesc'] ?? 'Error desconocido');
        }

        // Obtener datos del usuario (table1)
        final table1 = data['objects']?['table1']?['data'];
        if (table1 == null || table1.isEmpty) {
          throw Exception('No se encontraron datos del usuario');
        }
        final userData = table1[0];

        // Obtener código de perfil (table2)
        final table2 = data['objects']?['table2']?['data'];
        int codigoPerfil = 0;
        if (table2 != null && table2.isNotEmpty) {
          codigoPerfil = table2[0]['CODIGO_PERFIL'] ?? 0;
        }

        final combinedData = Map<String, dynamic>.from(userData);
        combinedData['CODIGO_PERFIL'] = codigoPerfil;

        return AuthModel.fromJson(combinedData);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
