import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signup_page.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'home_page.dart';
import 'package:glove_chat/globals.dart' as globals;
class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> performLogin() async {
    var url = Uri.parse('https://sg.rd-tech.org/mobile_api/login')
        .replace(queryParameters: {
      'email': _emailController.text,
      'password': _passwordController.text,
    });
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the token or proceed further
        final responseData = json.decode(response.body);
        // Assuming 'token' is a part of the response for successful login
        print(responseData['token']);
        globals.auth_token = responseData['token'];
        if (responseData['token'] != null) {
          Navigator.pushReplacementNamed(context, HomePage.id);
        } else {
          _showErrorDialog('Invalid login credentials');
        }
      } else {
        // If response is not OK, show error message
        _showErrorDialog('Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showErrorDialog('Network error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kcrimaryColor,
              kPrimaryColor,
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
              _buildLogo(),
              const SizedBox(height: 75),
              _buildHeader('LOGIN'),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                icon: Icons.email,
                hintText: 'Email',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _passwordController,
                icon: Icons.lock,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'LOGIN',
                onTap: performLogin,
              ),
              const SizedBox(height: 10),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'image/hand.png',
          height: 180,
        ),
        const SizedBox(height: 10),
        Text(
          'Glove',
          style: GoogleFonts.pacifico(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String text) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.pacifico(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
  }) {
    return CustomTextField(
      controller: controller,
      icon: icon,
      hintText: hintText,
      obscureText: obscureText,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'I don\'t have an account? ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignupPage.id);
          },
          child: const Text(
            ' Sign up',
            style: TextStyle(
              color: Color(0xff0f2e4d),
            ),
          ),
        ),
      ],
    );
  }
}
