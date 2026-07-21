import 'package:flutter/material.dart';

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Hello PRM393',
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}