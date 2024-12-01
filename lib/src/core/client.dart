import 'dart:convert';

import 'package:format/format.dart';
import 'package:http/http.dart' as http;
import 'package:turboself_dart/src/routes/endpoints.dart';
import 'package:turboself_dart/turboself_dart.dart';

/// The Turboself client managing the session.
class TurboselfClient {
  late final num hostId;
  late final num userId;
  late final String username;

  final String _baseUrl = "https://api-rest-prod.incb.fr/api/";
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  HostAPI get hosts => HostAPI(_get, _post, _put);

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

  Future<dynamic> _getURL(String path) async {
    final response = await http.get(Uri.parse(_baseUrl + path), headers: _headers);

    return _handleResponse(response);
  }

  Future<dynamic> _postURL(String path, Map<String, dynamic> body) async {
    final response = await http.post(Uri.parse(_baseUrl + path), headers: _headers, body: jsonEncode(body));

    return _handleResponse(response);
  }

  Future<dynamic> _putURL(String path, Map<String, dynamic> body) async {
    final response = await http.put(Uri.parse(_baseUrl + path), headers: _headers, body: jsonEncode(body));

    return _handleResponse(response);
  }

  Future<dynamic> _get(Endpoints endpoint, [Object? opts]) {
    if (opts != null) {
      return _getURL(endpoint.url.format(opts));
    } else {
      return _getURL(endpoint.url);
    }
  }

  Future<dynamic> _post(Endpoints endpoint, Map<String, dynamic> body, [Object? opts]) {
    if (opts != null) {
      return _postURL(endpoint.url.format(opts), body);
    } else {
      return _postURL(endpoint.url, body);
    }
  }

  Future<dynamic> _put(Endpoints endpoint, Map<String, dynamic> body, [Object? opts]) {
    if (opts != null) {
      return _putURL(endpoint.url.format(opts), body);
    } else {
      return _putURL(endpoint.url, body);
    }
  }

  /// Logs the user in thanks to credentials.
  Future<void> login(String username, String password) async {
    final response = await _post(Endpoints.login, {'username': username, 'password': password});
    print(response);
    _headers['Authorization'] = 'Bearer ${response['access_token']}';

    hostId = response['hoteId'];
    userId = response['userId'];
    this.username = username;
  }
}