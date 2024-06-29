class ErrorMessage {
  final String detail;

  ErrorMessage({required this.detail});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(detail: json['detail'] as String);
  }
}
