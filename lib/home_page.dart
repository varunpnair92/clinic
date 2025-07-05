import 'package:clinic/center_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredPage(
      child: Column(
        children: [
          const Text('Clinic Home', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: () => Get.toNamed('/register'), child: const Text("Register Patient")),
          ElevatedButton(onPressed: () => Get.toNamed('/search'), child: const Text("Search Patient")),
          ElevatedButton(onPressed: () => Get.toNamed('/doctor'), child: const Text("Doctor View")),
          ElevatedButton(onPressed: () => Get.toNamed('/reports'), child: const Text("Reports")),
        ],
      ),
    );
  }
}