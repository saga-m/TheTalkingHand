import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:glove_chat/globals.dart' as globals;
Future<void> registerUser(String email, String name, String phone, String gender,String birthday, String password) async {
  try {
    print('start');
    var response = await http.post(
        Uri.parse('https://sg.rd-tech.org/mobile_api/registration/'),
        body: {
          'email': email,
          'name': name,
          'phone': phone,
          'gender': gender,
          'birthday': birthday,
          'password': password,
        }
    );


    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      globals.auth_token = responseData['token'];
      // Handle successful registration, e.g., navigate to a confirmation screen
      print('Registration successful');
    } else {
      // Handle error or unsuccessful registration
      print('Failed to register: ${response.body}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
