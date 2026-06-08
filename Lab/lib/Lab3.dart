import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutDemo(),
    ),
  );
}

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  final List<Map<String, String>> movies = const [
    {
      "title": "Avatar",
      "subtitle": "Sample description",
    },
    {
      "title": "Inception",
      "subtitle": "Sample description",
    },
    {
      "title": "Interstellar",
      "subtitle": "Sample description",
    },
    {
      "title": "Joker",
      "subtitle": "Sample description",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 3 – Layout Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              "Now Playing",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            movie["title"]![0],
                          ),
                        ),
                        title: Text(movie["title"]!),
                        subtitle: Text(movie["subtitle"]!),
                      ),
                    ),
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