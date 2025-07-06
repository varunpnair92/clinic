// edit_visit_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller.dart';

class EditVisitController extends GetxController {
  final reasonController = TextEditingController();
  late int visitId;

  void init(Map<String, dynamic> data) {
    visitId = data['id'];
    reasonController.text = data['reason'] ?? '';
  }

  Future<void> saveChanges() async {
    if (visitId == null) {
      Get.snackbar('Error', 'Invalid visit ID');
      return;
    }

    final api = Get.find<ApiController>();
    await api.updateVisit(visitId, {
      'reason': reasonController.text,
    });

    Get.back();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
