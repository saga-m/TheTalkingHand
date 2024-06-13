import 'dart:convert';

import 'package:http/http.dart' as http;
Future<Map<String, dynamic>> login(String email, String password) async {
  var url = Uri.parse('https://sg-rd-tech.org/mobile_api/login/')
      .replace(queryParameters: {
    'email': email,
    'password': password
  });

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Token 91b874486d4e98e785febc28cb35906e468cf1e4',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to connect to the API: $e');
  }
}


