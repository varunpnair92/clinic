import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Doctor Panel")),
            ListTile(title: const Text("Reports"), onTap: () => Get.toNamed('/reports')),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const TextField(decoration: InputDecoration(labelText: 'Name or Phone')),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: const [
                SizedBox(height: 20),
                Text('Patient Details'),
                // Show fetched patient data
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Visit History'),
                Expanded(
                  child: ListView.separated(
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(color: Colors.grey),
                    itemBuilder: (context, index) => Container(
                      color: index % 2 == 0 ? Colors.teal.shade50 : Colors.orange.shade50,
                      padding: const EdgeInsets.all(8),
                      child: const Text("Visit notes here"),
                    ),
                  ),
                ),
                const TextField(decoration: InputDecoration(labelText: 'Remarks')),
                const TextField(decoration: InputDecoration(labelText: 'Prescription')),
                ElevatedButton(onPressed: () {}, child: const Text("Add Visit")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
