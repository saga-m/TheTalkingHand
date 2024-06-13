import 'package:flutter/material.dart';
import 'package:glove_chat/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:glove_chat/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  static const String id = 'profile page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? birthday;
  String? phone;
  String? email;
  String? gender;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    print(globals.auth_token);
    var url = Uri.parse('https://sg.rd-tech.org/mobile_api/profile/');
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
        setState(() {
          name = data['name'];
          email = data['email'];
          phone = data['phone'];
          gender = data['gender'];
          birthday = data['birthday'];
        });
      } else {
        throw Exception('Failed to load profile data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.pacifico(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kcrimaryColor, // corrected the typo in the color constant if needed
              kPrimaryColor, // corrected the typo in the color constant if needed
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView(
            children: [
              const SizedBox(height: 75),
              _buildProfileImage(),
              const SizedBox(height: 40),
              _buildWelcomeText(),
              const SizedBox(height: 20),
              _buildTextField(Icons.person_rounded, 'Name', (data) => setState(() => name = data), initialValue: name),
              _buildTextField(Icons.email, 'Email', (data) => setState(() => email = data), initialValue: email),
              _buildTextField(Icons.transgender, 'Gender', (data) => setState(() => gender = data), initialValue: gender),
              _buildTextField(Icons.date_range, 'Birthday', (data) => setState(() => birthday = data), initialValue: birthday),
              _buildTextField(Icons.phone, 'Phone', (data) => setState(() => phone = data), initialValue: phone),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Save',
                icon: Icons.save,
                onTap: () {
                  // Add save logic here
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Delete',
                icon: Icons.delete,
                onTap: () {
                  // Add save logic here
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Logout',
                icon: Icons.logout,
                onTap: () {
                  Navigator.pushNamed(context, LoginPage.id);
                  // Add logout logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }Widget _buildProfileImage() {
    return const Center(
      child: CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage('image/profile.jpg'),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Row(
      children: [
        Text(
          'Welcome',
          style: GoogleFonts.pacifico(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(IconData icon, String hintText, Function(String) onChanged, {String? initialValue}) {
    return CustomTextField(
      icon: icon,
      hintText: hintText,
      onChanged: onChanged,
      initialValue: initialValue,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_text_field.dart';
//
// class ProfilePage extends StatefulWidget {
//   static const String id = 'profile page';
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String? name;
//   String? birthday;
//   String? phone;
//   String? email;
//   String? gender;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileData();
//   }
//
//   Future<void> _fetchProfileData() async {
//     const String url = 'https://sg.rd-tech.org/mobile_api/profile/';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'token',
//         },
//       var request = http.Request('GET', Uri.parse('https://sg.rd-tech.org/mobile_api/profile/'));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//     );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           name = data['name'];
//           email = data['email'];
//           phone = data['phone'];
//           gender = data['gender'];
//           birthday = data['birthday'];
//         });
//       } else {
//         throw Exception('Failed to load profile data');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Profile',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               kcrimaryColor,
//               kPrimaryColor,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: ListView(
//             children: [
//               const SizedBox(height: 75),
//               _buildProfileImage(),
//               const SizedBox(height: 40),
//               _buildWelcomeText(),
//               const SizedBox(height: 20),
//               _buildTextField(Icons.person_rounded, 'Name', (data) => setState(() => name = data), initialValue: name),
//               _buildTextField(Icons.email, 'Email', (data) => setState(() => email = data), initialValue: email),
//               _buildTextField(Icons.transgender, 'Gender', (data) => setState(() => gender = data), initialValue: gender),
//               _buildTextField(Icons.date_range, 'Birthday', (data) => setState(() => birthday = data), initialValue: birthday),
//               _buildTextField(Icons.phone, 'Phone', (data) => setState(() => phone = data), initialValue: phone),
//               const SizedBox(height: 20),
//               CustomButton(
//                 text: 'Save',
//                 icon: Icons.save,
//                 onTap: () {
//                   // Add save logic here
//                 },
//               ),
//               const SizedBox(height: 12),
//               CustomButton(
//                 text: 'Logout',
//                 icon: Icons.logout,
//                 onTap: () {
//                   // Add logout logic here
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileImage() {
//     return const Center(
//       child: CircleAvatar(
//         radius: 80,
//         backgroundImage: AssetImage('image/profile.jpg'),
//       ),
//     );
//   }
//   Widget _buildWelcomeText() {
//     return Row(
//       children: [
//         Text(
//           'Welcome',
//           style: GoogleFonts.pacifico(
//             fontSize: 30,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField(IconData icon, String hintText, Function(String) onChanged, {String? initialValue}) {
//     return CustomTextField(
//       icon: icon,
//       hintText: hintText,
//       onChanged: onChanged,
//       initialValue: initialValue,
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_text_field.dart';
//
// class ProfilePage extends StatelessWidget {
//   ProfilePage({Key? key});
//
//   static String id = 'profile page';
//   String? name;
//   String? birthday;
//   String? phone;
//   String? email;
//   String? gender;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Profile',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration:  BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               kcrimaryColor,
//               kPrimaryColor,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: ListView(
//             children: [
//               SizedBox(height: 75),
//               Center(
//                 child: CircleAvatar(
//                   radius: 80,
//                   backgroundImage: AssetImage('image/profile.jpg'),
//                 ),
//
//               ),
//               SizedBox(height: 40),
//               Row(
//                 children: [
//                   Text(
//                     'welcome',
//                     style: GoogleFonts.pacifico(
//                       fontSize: 30,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               CustomTextField(
//                 icon: Icons.person_rounded,
//                 onChanged: (data) {
//                   name = data;
//                 },
//                 hintText: 'Name',
//               ),
//               SizedBox(height: 10),
//               CustomTextField(
//                 icon: Icons.email,
//                 onChanged: (data) {
//                   email = data;
//                 },
//                 hintText: 'Email',
//               ),
//               SizedBox(height: 10),
//               CustomTextField(
//                 icon: Icons.transgender,
//                 onChanged: (data) {
//                   gender = data;
//                 },
//                 hintText: 'F/M',
//               ),
//               SizedBox(height: 10),
//               CustomTextField(
//                 icon: Icons.date_range,
//                 onChanged: (data) {
//                   birthday = data;
//                 },
//                 hintText: 'Birthday',
//               ),
//               SizedBox(height: 10),
//               CustomTextField(
//                 icon: Icons.phone,
//                 onChanged: (data) {
//                   phone = data;
//                 },
//                 hintText: 'Phone',
//               ),
//               SizedBox(height: 20),
//               CustomButton(
//                 text: 'Save',
//                 icon: Icons.save,
//               ),
//               SizedBox(height: 12),
//           CustomButton(
//             text: 'Logout',
//             icon: Icons.logout ,
//           ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
