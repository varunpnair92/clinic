// edit_visit_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller.dart';

class EditVisitController extends GetxController {
  final reasonController = TextEditingController();
  final prescriptionController = TextEditingController();
  late int visitId;

  void init(Map<String, dynamic> data) {
    visitId = data['id'];
    reasonController.text = data['reason'] ?? '';
    final prescriptions = data['prescriptions'] ?? [];
    if (prescriptions is List) {
      prescriptionController.text = prescriptions
          .map((p) {
            final name = p['medicine_name'] ?? '';
            final inst = p['instructions'] ?? '';
            if (inst.toString().trim().isNotEmpty) {
              return '$name - $inst';
            }
            return name.toString();
          })
          .where((s) => s.trim().isNotEmpty)
          .join('\n');
    }
  }

  Future<void> saveChanges() async {
    final api = Get.find<ApiController>();
    final success = await api.updateVisit(visitId, {
      'reason': reasonController.text,
      'prescription': prescriptionController.text,
    });

    if (success) {
      Get.back();
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    prescriptionController.dispose();
    super.onClose();
  }
}
