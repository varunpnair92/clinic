// edit_visit.dart
import 'package:clinic/edit_controllre.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditVisitPage extends StatefulWidget {
  final Map<String, dynamic> visitData;
  const EditVisitPage({required this.visitData, super.key});

  @override
  State<EditVisitPage> createState() => _EditVisitPageState();
}

class _EditVisitPageState extends State<EditVisitPage> {
  late EditVisitController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EditVisitController());
    controller.init(widget.visitData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Visit - ${widget.visitData['visit_date'] ?? ''}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.reasonController,
              decoration: const InputDecoration(
                labelText: 'Remarks / Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.prescriptionController,
              decoration: const InputDecoration(
                labelText: 'Prescriptions',
                border: OutlineInputBorder(),
                helperText: 'One per line, e.g. Paracetamol - 1-0-1',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
