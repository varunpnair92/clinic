import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientDetailPage extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientDetailPage({required this.patient, super.key});

  @override
  Widget build(BuildContext context) {
    final apiController = Get.find<ApiController>();

    // Pre-fill controllers
    apiController.nameCtrl.text = patient['name'] ?? '';
    apiController.ageCtrl.text = '${patient['age'] ?? ''}';
    apiController.genderCtrl.text = patient['gender'] ?? '';
    apiController.phoneCtrl.text = patient['phone'] ?? '';
    apiController.addressCtrl.text = patient['address']?['address'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: apiController.nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: apiController.ageCtrl, decoration: const InputDecoration(labelText: 'Age')),
            TextField(controller: apiController.genderCtrl, decoration: const InputDecoration(labelText: 'Gender')),
            TextField(controller: apiController.phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: apiController.addressCtrl, decoration: const InputDecoration(labelText: 'Address')),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedData = {
                  'name': apiController.nameCtrl.text,
                  'age': int.tryParse(apiController.ageCtrl.text) ?? 0,
                  'gender': apiController.genderCtrl.text,
                  'phone': apiController.phoneCtrl.text,
                  'address': {
                    'address': apiController.addressCtrl.text,
                  },
                };
                await apiController.updatePatient(patient['id'], updatedData);
                Get.back(); // Go back after update
              },
              child: const Text('Update Patient'),
            ),
          ],
        ),
      ),
    );
  }
}
