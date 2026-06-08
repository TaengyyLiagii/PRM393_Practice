import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: CoreWidgetsDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Core Widgets Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Text Widget
            const Text(
              "Welcome to Flutter UI",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Icon Widget
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 50,
            ),

            const SizedBox(height: 20),

            // Image Widget
            Image.network(
              "https://picsum.photos/300/200",
              height: 200,
            ),

            const SizedBox(height: 20),

            // Card + ListTile
            Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("John Doe"),
                subtitle: const Text("Flutter Developer"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}