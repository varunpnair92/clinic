import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  final String baseUrl = 'http://192.168.1.40:8000/clinic';
    var selectedPatient = Rxn<Map>();  // <-- This line is essential


  var searchResults = [].obs;
  var loading = false.obs;

  Future<void> searchPatient(String query) async {
    loading.value = true;
    try {
      final res = await http.get(Uri.parse('$baseUrl/search/?q=$query'));
      if (res.statusCode == 200) {
        searchResults.value = json.decode(res.body);
      } else {
        searchResults.value = [];
      }
    } catch (e) {
      searchResults.value = [];
    } finally {
      loading.value = false;
    }
  }

  Future<void> registerPatient(Map<String, dynamic> data) async {
  try {
    print(data);
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      Get.snackbar(
        'Success',
        'Patient registered successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Failed',
        'Registration failed: ${response.body}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
    );
  }
}


Future<void> addVisit({required int patientId, required String reason, String? prescription}) async {
  final data = {
    'patient_id': patientId,
    'reason': reason,
    'prescriptions': prescription != null && prescription.trim().isNotEmpty
        ? [
            {
              'medicine_name': prescription,
              'instructions': ''
            }
          ]
        : [],
  };

  try {
    await http.post(
      Uri.parse('$baseUrl/add/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}


Future<void> updateVisit(int visitId, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/update_visit/$visitId/'); // Assuming RESTful endpoint
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar('Success', 'Visit updated successfully');
        // Optionally refresh patient data after update:
        if (selectedPatient.value != null) {
          await searchPatient(selectedPatient.value!['name'] ?? '');
        }
      } else {
        Get.snackbar('Error', 'Failed to update visit: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    }
  }



}