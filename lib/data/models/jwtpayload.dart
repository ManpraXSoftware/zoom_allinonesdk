class JwtPayload {
  final String sdkKey;
  final String appKey;
  final int iat;
  final int exp;
  final String role;
  final int tokenExp;
  final int? mn; // Nullable meeting ID

  JwtPayload({
    required this.sdkKey,
    required this.appKey,
    required this.iat,
    required this.exp,
    required this.role,
    required this.tokenExp,
    this.mn, // Nullable meeting ID
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> payload = {
      'sdkKey': sdkKey,
      'appKey': appKey,
      'iat': iat,
      'exp': exp,
      'role': role == "1" ? "1" : "0", // If role is 1, use 1; otherwise, use 0
      'tokenExp': tokenExp,
    };

    if (mn != null) {
      payload['mn'] = mn;
    }

    return payload;
  }
}
