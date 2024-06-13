import 'package:flutter/material.dart';

class HoverExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MouseRegion(
            onEnter: (PointerEvent details) => print("Hover In"),
            onExit: (PointerEvent details) => print("Hover Out"),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Hover Over Me',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(HoverExample());
}