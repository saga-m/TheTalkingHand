import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:glove_chat/widgets/sing_language.dart';
import 'package:glove_chat/globals.dart' as globals;

Future<List<SingLanguage>> fetchLessons() async {
  print(globals.auth_token);
  var url = Uri.parse('https://sg.rd-tech.org/mobile_api/lessons/');
  String? token = globals.auth_token;
  var headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'application/json', // Replace 'your_actual_token_here' with your actual API token.
  };

  var request = http.Request('GET', url);
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      List<SingLanguage> lessons = data.map<SingLanguage>((lesson) {
        return SingLanguage(
          title: lesson['title'] as String,
          thumbnailUrl: "https://sg.rd-tech.org" + lesson['thumbnail'] as String,
          videoUrl: lesson['url'] as String,
        );
      }).toList();
      return lessons;
    } else {
      throw Exception('Failed to load profile data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching profile data: $e');
    return [];
  }
}



