class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => 'ApiException ($code): $message';
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message, {super.code});
}

class ValidationException extends ApiException {
  final Map<String, dynamic> errors;
  ValidationException(super.message, this.errors);
}
