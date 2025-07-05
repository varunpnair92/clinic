import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditVisitPage extends StatefulWidget {
  final Map<String, dynamic> visitData;

  // Cast dynamic map to Map<String, dynamic> here
  EditVisitPage({required Map<dynamic, dynamic> visitData, Key? key})
      : visitData = Map<String, dynamic>.from(visitData),
        super(key: key);

  @override
  State<EditVisitPage> createState() => _EditVisitPageState();
}

class _EditVisitPageState extends State<EditVisitPage> {
  late TextEditingController reasonController;

  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController(text: widget.visitData['reason']);
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = Get.put(ApiController());

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Visit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Update visit using GetX controller method
                await api.updateVisit(widget.visitData['id'], {
                  'reason': reasonController.text,
                  // Add other fields if you want here
                });
                Get.back(); // Close the edit page
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
