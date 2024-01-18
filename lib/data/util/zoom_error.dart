class ZoomError implements Exception {
  final String message;

  ZoomError(this.message);

  @override
  String toString() {
    return 'ZoomError: $message';
  }
}
