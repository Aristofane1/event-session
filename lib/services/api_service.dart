import 'dart:developer';
import 'package:dio/dio.dart';
import '../config/exceptions/api_exceptions.dart';

class ApiService {
  late final Dio _dio;

  ApiService({required String baseUrl, String? token}) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    _dio = Dio(options);

    // Intercepteurs (facultatif mais utile)
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  // ======= GESTION DES REQUÊTES =========

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: query);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, dynamic data, {Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.post(endpoint, data: data, queryParameters: query);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> uploadFile(String endpoint, String fileField, String filePath, {Map<String, dynamic>? fields}) async {
    try {
      FormData formData = FormData.fromMap({
        if (fields != null) ...fields,
        fileField: await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(endpoint, data: formData);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  // ======= TRAITEMENT DES RÉPONSES ET ERREURS =========

  dynamic _handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else if (response.statusCode == 422) {
      throw ValidationException('Données invalides', response.data['errors'] ?? {});
    } else {
      throw ServerException('Erreur du serveur', code: response.statusCode);
    }
  }

  void _handleError(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw NetworkException("Délai de connexion dépassé");
      }

      if (error.type == DioExceptionType.badResponse) {
        throw ServerException("Erreur de réponse du serveur", code: error.response?.statusCode);
      }

      if (error.type == DioExceptionType.cancel) {
        throw ApiException("Requête annulée");
      }

      throw ApiException("Erreur réseau inconnue");
    } else {
      log('Erreur non interceptée : $error');
      throw ApiException("Erreur inattendue");
    }
  }

  // Ajout de headers dynamiques (ex: nouveau token)
  void setHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }
}
