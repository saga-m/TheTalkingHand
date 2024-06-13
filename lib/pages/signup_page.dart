import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../models/signup_api.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'home_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  static String id = 'SignupPage';
  String? email;
  String? password;
  String? name;
  String? phone;
  String? convertPassword;
  String? gender;
  String? birthday;

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
              const SizedBox(height: 70),
              _buildLogo(),
              const SizedBox(height: 55),
              _buildHeader('SIGNUP'),
              const SizedBox(height: 20),
              _buildTextField(Icons.phone, '+20 000 000 0000', (data) => phone = data),
              const SizedBox(height: 10),
              _buildTextField(Icons.person, 'Name', (data) => name = data),
              const SizedBox(height: 10),
              _buildTextField(Icons.transgender, 'F/M', (data) => gender = data),
              const SizedBox(height: 10),
              _buildTextField(Icons.email, 'Email', (data) => email = data),
              const SizedBox(height: 10),
              _buildTextField(Icons.date_range, 'Birthday', (data) => birthday = data),
              const SizedBox(height: 10),
              _buildTextField(Icons.lock, 'Password', (data) => password = data),
              const SizedBox(height: 10),
              _buildTextField(Icons.lock, 'Confirm Password', (data) => convertPassword = data),
              const SizedBox(height: 20),
              CustomButton(
                text: 'SIGNUP',
                onTap: () {
                  if (email != null && name != null && phone != null && gender != null && password != null && password == convertPassword && birthday != null) {
                    print('if');
                    registerUser(email!, name!, phone!, gender!, birthday!, password!);

                    Navigator.pushNamed(context, HomePage.id);
                  } else {
                    print('else');
                    // Show an error message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please fill all fields and make sure passwords match.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
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
          height: 160,
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

  Widget _buildTextField(IconData icon, String hintText, ValueChanged<String> onChanged) {
    return CustomTextField(
      icon: icon,
      hintText: hintText,
      onChanged: onChanged,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            ' Log in',
            style: TextStyle(
              color: Color(0xff0f2e4d),
            ),
          ),
        ),
      ],
    );
  }
}







