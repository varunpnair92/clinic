import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  final String baseUrl = 'http://192.168.1.40:8000/clinic';

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
      await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
    } catch (e) {
      rethrow;
    }
  }
}