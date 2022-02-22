import 'dart:convert';

/// https://stackoverflow.com/a/61055817

class Jwt {
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid token.');
    }

    final payload = _decodeBase64(parts[1]);
    final dynamic payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw const FormatException('Invalid payload.');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    var output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64 string.');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static bool isExpired(String token) {
    final expirationDate = expiryDate(token);
    if (expirationDate != null) {
      return DateTime.now().isAfter(expirationDate);
    } else {
      return false;
    }
  }

  static Duration? remaingTime(String token) {
    final date = expiryDate(token);
    if (date == null) return null;
    return date.difference(DateTime.now().toUtc());
  }

  static DateTime? expiryDate(String token) {
    final payload = parseJwt(token);
    if (payload['exp'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).add(Duration(seconds: payload['exp'] as int));
    }
    return null;
  }
}
