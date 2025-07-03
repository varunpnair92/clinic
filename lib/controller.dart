import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PatientController extends GetxController {
  final name = ''.obs;
  final age = ''.obs;
  final gender = 'Male'.obs;
  final contact = ''.obs;

  final formKey = GlobalKey<FormState>();

  void register() {
    if (formKey.currentState!.validate()) {
      Get.dialog(
        AlertDialog(
          title: const Text('Success'),
          content: Text(
            'Patient Registered:\n'
            'Name: ${name.value}\n'
            'Age: ${age.value}\n'
            'Gender: ${gender.value}\n'
            'Contact: ${contact.value}',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
