import 'dart:convert';
import 'dart:typed_data';
import 'package:clinic/shared.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  final String baseUrl = ApiConstants.baseUrl; // Use the base URL from shared.dart
    var selectedPatient = Rxn<Map>();  // <-- This line is essential


  var searchResults = [].obs;
  var loading = false.obs;


  var loggedInUser = {}.obs;

Future<bool> loginUser(String username, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    loggedInUser.value = jsonDecode(response.body);
    return true;
  } else {
    return false;
  }
}


  Future<void> searchPatient(String query) async {
    //searchResults.value = [];
    loading.value = true;
    print('Searching for: $query');
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
  print("registerPatient called with data: $data");

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      final opNumber = responseData['op_number'] ?? 'N/A';

      Get.snackbar(
        'Success',
        'Patient registered successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Get.defaultDialog(
        title: 'OP Number',
        content: Text('New OP Number: $opNumber'),
        textConfirm: 'OK',
        onConfirm: () => Get.back(), // close dialog
      );
    } else if (response.statusCode == 400) {
      final opNumber = responseData['existing_op_number'] ?? 'N/A';

      Get.snackbar(
        'Already Registered',
        'Patient exists',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Get.defaultDialog(
        title: 'Patient Exists',
        content: Text('Existing OP Number: $opNumber'),
        textConfirm: 'OK',
        onConfirm: () => Get.back(), // close dialog
      );
    } else {
      Get.snackbar(
        'Failed',
        'Registration failed: ${response.body}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  } catch (e) {
    print('Error during registration: $e');
    Get.snackbar(
      'Error',
      'Network error: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}


Future<void> addVisit({
  required int patientId,
  required String reason,
  String? prescription,
  String? xrayFilePath, // optional image path
}) async {
  final uri = Uri.parse('$baseUrl/add/');

  final request = http.MultipartRequest('POST', uri);
  request.fields['patient_id'] = patientId.toString();
  request.fields['reason'] = reason;

  if (prescription != null && prescription.trim().isNotEmpty) {
    final prescriptionsJson = jsonEncode([
      {'medicine_name': prescription, 'instructions': ''}
    ]);
    request.fields['prescriptions'] = prescriptionsJson;
  } else {
    request.fields['prescriptions'] = jsonEncode([]);
  }

  if (xrayFilePath != null && xrayFilePath.isNotEmpty) {
    request.files.add(await http.MultipartFile.fromPath('xray_image', xrayFilePath));
  }

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Visit added');
    } else {
      Get.snackbar('Error', 'Failed: ${response.body}');
    }
  } catch (e) {
    Get.snackbar('Error', 'Network error: $e');
  }
}


Future<int?> addVisitWithImage({
  required int patientId,
  required String reason,
  required String prescription,
  Uint8List? xrayBytes,
  String? fileName,
}) async {
  final uri = Uri.parse('$baseUrl/add/');
  final request = http.MultipartRequest('POST', uri);

  request.fields['patient_id'] = patientId.toString();
  request.fields['reason'] = reason;
  request.fields['prescriptions'] = json.encode([
    {
      'medicine_name': prescription,
      'instructions': ''
    }
  ]);

  // ✅ Add file if available
  if (xrayBytes != null && fileName != null && fileName.isNotEmpty) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'xray', // must match Django view
        xrayBytes,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'), // Add `import 'package:http_parser/http_parser.dart';`
      ),
    );
  }

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData['visit_id'];
    } else {
      print('Failed: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
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
        await Future.delayed(const Duration(seconds: 1));  // delay here
  Get.back();
      } else {
        Get.snackbar('Error', 'Failed to update visit: ${response.body}');
        await Future.delayed(const Duration(seconds: 1));  // delay here
  Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    }
  }




}