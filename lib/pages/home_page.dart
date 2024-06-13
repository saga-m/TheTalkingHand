import 'package:flutter/material.dart';
import 'package:glove_chat/grid_view_screen/life_track.dart';
import 'package:google_fonts/google_fonts.dart';
import '../grid_view_screen/about_page.dart';
import '../grid_view_screen/connection_page.dart';
import '../grid_view_screen/lesson_page.dart';
import 'profile_page.dart';


import '../constants.dart';
import '../widgets/custom_grid_viwe.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  static String id = 'home page';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {'imagePath': 'image/lesson.png', 'text': 'Lesson'},
      {'imagePath': 'image/life_track.jpg', 'text': 'Life Track'},
      {'imagePath': 'image/glove_connection.png', 'text': 'Glove Connection'},
      {'imagePath': 'image/about.png', 'text': 'About'},
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
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
              SizedBox(height: 75,),
              Center(
                child: Image.asset(
                  'image/hand.png',
                  height: 130,
                ),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 40,),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Set to 2 to have two items next to each other
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemCount: gridItems.length, // Number of items in the grid
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        // Navigate to the lesson page when tapped
                        Navigator.pushNamed(context, LessonPage.id);
                      } else if (index == 1) {
                        // Navigate to the life track page when tapped
                        Navigator.pushNamed(context, LifeTrack.id); // Define the route accordingly
                      } else if (index == 2) {
                        // Navigate to the chat page when tapped
                        Navigator.pushNamed(context, Bluetooth.id);
                      } else if (index == 3) {
                        // Navigate to the about page when tapped
                        Navigator.pushNamed(context, AboutPage.id);
                      }
                    },
                    child: GridViewExample(
                      imagePath: gridItems[index]['imagePath'],
                      text: gridItems[index]['text'],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.white, // Set the background color to match overall background
        selectedItemColor: Colors.black,
        elevation: 0, // Remove the bottom navigation bar's elevation
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, ProfilePage.id);
          }
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:glove_chat/grid_view_screen/about_page.dart';
// import 'package:glove_chat/grid_view_screen/lesson_page.dart';
// import 'package:glove_chat/pages/profile_page.dart';
//
// import '../constants.dart';
// import '../widgets/custom_grid_viwe.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key});
//
//   static String id = 'home page';
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> gridItems = [
//       {'imagePath': 'image/lesson.png', 'text': 'Lesson'},
//       {'imagePath': 'image/life_track.jpg', 'text': 'Life Track'},
//       {'imagePath': 'image/glove_connection.png', 'text': 'Glove Connection'},
//       {'imagePath': 'image/about.png', 'text': 'About'},
//     ];
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               kPrimaryColor,
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
//               SizedBox(height: 75,),
//               Center(
//                 child: Image.asset(
//                   'image/hand.png',
//                   height: 120,
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Glove',
//                     style: TextStyle(
//                       fontSize: 32,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 40,),
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Set to 2 to have two items next to each other
//                   childAspectRatio: 1.1,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 20,
//                 ),
//                 itemCount: gridItems.length, // Number of items in the grid
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       if (index == 3) {
//                         // Navigate to the about page when tapped
//                         Navigator.pushNamed(context, AboutPage.id);
//                       } else {
//                         // Navigate to the lesson page when tapped
//                         Navigator.pushNamed(context, LessonPage.id);
//                       }
//                     },
//                     child: GridViewExample(
//                       imagePath: gridItems[index]['imagePath'],
//                       text: gridItems[index]['text'],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Profile',
//           ),
//         ],
//         backgroundColor: Colors.white, // Set the background color to match overall background
//         selectedItemColor: Colors.black,
//         elevation: 0, // Remove the bottom navigation bar's elevation
//         onTap: (int index) {
//           if (index == 1) {
//             Navigator.pushNamed(context, ProfilePage.id);
//           }
//         },
//       ),
//     );
//   }
// }
