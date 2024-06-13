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



// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:glove_chat/globals.dart' as globals;
// import 'package:glove_chat/widgets/sing_language.dart';
// Future<List<SingLanguage>> fetchLessons() async {
//   print(globals.auth_token);
//   var url = Uri.parse('https://sg.rd-tech.org/mobile_api/lessons/');
//   String? token = globals.auth_token;
//   var headers = {
//     'Authorization': 'Token $token',
//     'Content-Type': 'application/json', // Replace 'your_actual_token_here' with your actual API token.
//   };
//
//   var request = http.Request('GET', url);
//   request.headers.addAll(headers);
//
//   try {
//     http.StreamedResponse response = await request.send();
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       var responseBody = await response.stream.bytesToString();
//       var data = jsonDecode(responseBody);
//       List<SingLanguage> lessons = data.map<SingLanguage>((lesson) {
//         return SingLanguage(
//           title: lesson['title'] as String,
//           thumbnailUrl: "https://sg.rd-tech.org" + lesson['thumbnail'] as String,
//           videoUrl: lesson['url'] as String,
//         );
//       }).toList();
//       return lessons;
//     } else {
//       throw Exception('Failed to load profile data with status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching profile data: $e');
//     return [];
//   }
// }

// Future<List<Lesson>> fetchLessons() async {
//   const String apiUrl = 'https://sg-rd-tech.org/mobile_api/lessons/';
//   try {
//     final response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body).map<Lesson>((json) => Lesson.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load lessons with status code: ${response.statusCode}');
//     }
//   } on SocketException catch (e) {
//     throw Exception('Failed to load lessons: SocketException, failed host lookup. Error: $e');
//   } catch (e) {
//     throw Exception('Failed to load lessons with Error: $e');
//   }
// }




// Future<List<Lesson>> fetchLessons() async {
//   const String apiUrl = 'https://sg-rd-tech.org/mobile_api/lessons/';
//   const String token = '91b874486d4e98e785febc28cb35906e468cf1e4'; // Use your actual token
//
//   try {
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Token $token',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       List<dynamic> lessonsJson = jsonDecode(response.body);
//       return lessonsJson.map((json) => Lesson.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load lessons');
//     }
//   } catch (e) {
//     throw Exception('Failed to load lessons: $e');
//   }
// }


// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'lesson.dart';
//
// Future<List<Lesson>> fetchLessons() async {
//   final response = await http.get(
//     Uri.parse('https://sg.rd-tech.org/mobile_api/lessons/'),
//     headers: {
//       'Authorization': '91b874486d4e98e785febc28cb35906e468cf1e4'
//     },
//   );
//
//   if (response.statusCode == 200) {
//     List jsonResponse = json.decode(response.body);
//     return jsonResponse.map((lesson) => Lesson.fromJson(lesson)).toList();
//   } else {
//     throw Exception('Failed to load lessons');
//   }
// }