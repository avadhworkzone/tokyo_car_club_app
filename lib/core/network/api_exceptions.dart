class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

ApiException handleApiError(dynamic error) {
  if (error.toString().contains("SocketException")) {
    return ApiException("No Internet Connection");
  } else if (error.response?.statusCode == 404) {
    return ApiException("Data not found");
  } else if (error.response?.statusCode == 500) {
    return ApiException("Server error");
  }
  return ApiException("Something went wrong");
}
