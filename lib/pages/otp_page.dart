import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glove_chat/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/services.dart';
class OtpPage extends StatelessWidget {

   OtpPage({super.key});

  static String id = 'OtpPage';
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
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
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          SizedBox(height: 75,),
                          Image.asset('image/hand.png',
                              height: 180,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text(
                                      'Glove',
                                      style: GoogleFonts.pacifico(
                                          fontSize: 32,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                      ),
                                  ),
                              ],
                          ),
                          SizedBox(
                              height: 40,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text('The code will be send again! ',
                                      style: TextStyle(
                                          color: Colors.white,
                                      ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                          // Navigator.pushNamed(context, SignupPage.id);
                                      },
                                      child: Text(' Resend.',
                                          style: TextStyle(
                                              color: Color(0xff0f2e4d),
                                          ),
                                      ),
                                  )
                              ],
                          ),
                          SizedBox(
                              height: 20,
                          ),
                          Form(
                              child:
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                SizedBox(
                                    height: 68,
                                width: 64,
                                child: TextFormField(
                                    onChanged: (value){
                                        if (value.length ==1){
                                            FocusScope.of(context).nextFocus();
                                        }
                                    },
                                    onSaved: (pin1){},
                                    decoration: InputDecoration(
                                        hintText: "0"
                                    ),
                                    style: Theme.of(context).textTheme.headline6,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                  ],
                              ),
                                ),
                                SizedBox(
                                    height: 68,
                                    width: 64,
                                    child: TextFormField(
                                        onChanged: (value){
                                            if (value.length ==1){
                                                FocusScope.of(context).nextFocus();
                                            }
                                        },
                                        onSaved: (pin1){},
                                        decoration: InputDecoration(
                                            hintText: "0"
                                        ),
                                        style: Theme.of(context).textTheme.headline6,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter.digitsOnly,
                                        ],
                                    ),
                                ),
                                SizedBox(
                                    height: 68,
                                    width: 64,
                                    child: TextFormField(
                                        onChanged: (value){
                                            if (value.length ==1){
                                                FocusScope.of(context).nextFocus();
                                            }
                                        },
                                        onSaved: (pin1){},
                                        decoration: InputDecoration(
                                            hintText: "0"
                                        ),
                                        style: Theme.of(context).textTheme.headline6,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter.digitsOnly,
                                        ],
                                    ),
                                ),
                                SizedBox(
                                    height: 68,
                                    width: 64,
                                    child: TextFormField(
                                        onChanged: (value){
                                            if (value.length ==1){
                                                FocusScope.of(context).nextFocus();
                                            }
                                        },
                                        onSaved: (pin1){},
                                        decoration: InputDecoration(
                                            hintText: "0"
                                        ),
                                        style: Theme.of(context).textTheme.headline6,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter.digitsOnly,
                                        ],
                                    ),
                                ),
                            ],
                          ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            child: CustomButton(
                                onTap:(){
                                    Navigator.pushNamed(context, HomePage.id);
                                },
                                text: 'Confirm',
                            ),
                          ),
                      ],
                  ),
              ),
          ),
      );
  }
}
