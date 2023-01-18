import 'dart:io';

import 'package:http/http.dart' as http;

mixin StripeHelper {
  static String secret =
      "sk_test_y39fwyx9vqEV1Wu1YdYSDpd9";

  static String publishableKey =
      "pk_test_sber4fBKT03hPBXMqnPhvgQ4";

  static Map<String, String> get headers {
    return {
      HttpHeaders.authorizationHeader: "Bearer $secret",
      "Content-type": "application/x-www-form-urlencoded",
    };
  }
}
