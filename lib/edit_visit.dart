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
      appBar: AppBar(title: const Text('Edit Visit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
              maxLines: null,
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
