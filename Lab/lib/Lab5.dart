import 'package:flutter/material.dart';

void main() {
  runApp(const MyAppp());
}

class MyAppp extends StatelessWidget {
  const MyAppp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 5',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Exercise5Screen(),
    );
  }
}

class Exercise5Screen extends StatelessWidget {
  const Exercise5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = [
      'Movie A',
      'Movie B',
      'Movie C',
      'Movie D',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Errors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Fix lỗi ListView trong Column
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.movie),
                    title: Text(movies[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}