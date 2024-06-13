import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  static String id = 'about page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
           ' About Us',
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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildItem(context, 'Mobile', 'image/mobile_phone.png', 'Mobile development involves creating software for mobile devices.'),
                _buildItem(context, 'Backend', 'image/backend.png', 'Backend development handles the server-side logic and database management.'),
                _buildItem(context, 'Embedded','image/embedded.png', 'Embedded systems programming involves working directly with hardware interfaces.',),
                _buildItem(context, 'Web', 'image/web.png', 'Web development focuses on building applications that run in a web browser.'),
                _buildItem(context, 'AI', 'image/ai.png', 'AI development involves creating algorithms that simulate human intelligence.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String text, String imagePath, String description) {
    return GestureDetector(
      onTap: () {
        _showDescription(context, text, description);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        width: 300,
        height: 300,
        decoration: BoxDecoration(
           color: Color(0xff2e4b69),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(imagePath),
          ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 30,
                color: Colors.black45,
                spreadRadius: 0,
                offset: Offset(10, 10),
              ),
            ]
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // backgroundColor: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  void _showDescription(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



