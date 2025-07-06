import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceptionistHomePage extends StatelessWidget {
  const ReceptionistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receptionist Panel")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text("Register Patient"),
              onPressed: () => Get.toNamed('/register'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Search Patient"),
              onPressed: () => Get.toNamed('/search'),
            ),
          ],
        ),
      ),
    );
  }
}
