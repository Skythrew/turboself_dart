import 'dart:convert';

import 'package:http/http.dart' as http;

const String _baseUrl = "https://api-rest-prod.incb.fr/api/";

dynamic _handleResponse(http.Response response) {
  if (response.statusCode < 200 || response.statusCode > 299) {
    final jsonResponse = jsonDecode(response.body);
    throw Exception('(${response.statusCode}) ${jsonResponse['message']}');
  }

  if (response.body.isEmpty) {
    return null;
  }

  final jsonResponse = jsonDecode(response.body);

  return jsonResponse;
}

Future<dynamic> getURL(String path, Map<String, String> headers) async {
  final response = await http.get(Uri.parse(_baseUrl + path), headers: headers);

  return _handleResponse(response);
}

Future<dynamic> postURL(
    String path, Map<String, dynamic> body, Map<String, String> headers) async {
  final response = await http.post(Uri.parse(_baseUrl + path),
      headers: headers, body: jsonEncode(body));

  return _handleResponse(response);
}

Future<dynamic> putURL(
    String path, Map<String, dynamic> body, Map<String, String> headers) async {
  final response = await http.put(Uri.parse(_baseUrl + path),
      headers: headers, body: jsonEncode(body));

  return _handleResponse(response);
}
