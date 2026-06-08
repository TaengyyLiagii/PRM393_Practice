import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InputControlsDemo(),
    ),
  );
}

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double rating = 50;
  bool isMovieActive = false;
  String? selectedGenre;
  DateTime? selectedDate;

  Future<void> openDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise 2 – Input Controls"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider
            const Text(
              "Rating (Slider)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Slider(
              value: rating,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),

            Text("Current value: ${rating.toInt()}"),

            const SizedBox(height: 20),

            // Switch
            const Text(
              "Active (Switch)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Is movie active?"),
                Switch(
                  value: isMovieActive,
                  onChanged: (value) {
                    setState(() {
                      isMovieActive = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // RadioListTile
            const Text(
              "Genre (RadioListTile)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            RadioListTile<String>(
              title: const Text("Action"),
              value: "Action",
              groupValue: selectedGenre,
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text("Comedy"),
              value: "Comedy",
              groupValue: selectedGenre,
              onChanged: (value) {
                setState(() {
                  selectedGenre = value;
                });
              },
            ),

            Text(
              "Selected genre: ${selectedGenre ?? "None"}",
            ),

            const SizedBox(height: 20),

            // Date Picker Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: openDatePicker,
                child: const Text("Open Date Picker"),
              ),
            ),

            const SizedBox(height: 10),

            if (selectedDate != null)
              Text(
                "Selected date: "
                "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
          ],
        ),
      ),
    );
  }
}