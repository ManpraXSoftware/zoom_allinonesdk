import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:zoom_allinonesdk/data/models/jwtpayload.dart';

class JwtGenerator {
  String generate(
      {required String key,
      required String secret,
      int meetingId = 0,
      String role = "0"}) {
    final payload = JwtPayload(
      sdkKey: key,
      appKey: key,
      iat: (DateTime.now().millisecondsSinceEpoch / 1000).floor() - 30,
      exp: (DateTime.now().millisecondsSinceEpoch / 1000).floor() + 60 * 60 * 2,
      role: role, // If role is 1, use 1; otherwise, use 0
      tokenExp:
          (DateTime.now().millisecondsSinceEpoch / 1000).floor() + 60 * 60 * 2,
      mn: meetingId, // Nullable Meeting ID
    );

    final header = json.encode({'alg': 'HS256', 'typ': 'JWT'});
    final encodedHeader = base64Url.encode(utf8.encode(header));
    final encodedPayload =
        base64Url.encode(utf8.encode(json.encode(payload.toJson())));

    final signature = Hmac(sha256, secret.codeUnits)
        .convert('$encodedHeader.$encodedPayload'.codeUnits);
    final encodedSignature = base64Url.encode(signature.bytes);

    return '$encodedHeader.$encodedPayload.$encodedSignature';
  }
}
