class ApiResponse<T> {
  final bool error;
  final String message;
  final T data;

  ApiResponse({required this.error, required this.message, required this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromData,
  ) {
    return ApiResponse(
      error: json['error'],
      message: json['message'],
      data: fromData(json['data']),
    );
  }
}
