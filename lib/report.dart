import 'package:clinic/center_page.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredPage(
      child: Column(
        children: [
          const Text('Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: const Text("Daily Summary")),
          ElevatedButton(onPressed: () {}, child: const Text("Between Dates")),
          ElevatedButton(onPressed: () {}, child: const Text("Patient Summary")),
        ],
      ),
    );
  }
}
