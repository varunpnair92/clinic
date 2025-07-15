import 'package:clinic/controller.dart';
import 'package:clinic/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiController = Get.put(ApiController());
    final queryController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Search Patient')),
      body: Column(
        children: [
          TextField(
            controller: queryController,
            decoration: const InputDecoration(
              labelText: 'Name or Phone',
              contentPadding: EdgeInsets.all(8),
            ),
            onSubmitted: (val) => apiController.searchPatient(val),
          ),
          ElevatedButton(
            onPressed: () {
              apiController.searchPatient(queryController.text);
            },
            child: const Text('Search'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (apiController.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (apiController.searchResults.isEmpty) {
                return const Center(child: Text('No patients found.'));
              }
              return ListView.builder(
                itemCount: apiController.searchResults.length,
                itemBuilder: (context, index) {
                  final patient = apiController.searchResults[index];
                  return ListTile(
                    title: Text(patient['name']),
                    subtitle: Text('OP: ${patient['op_number']}'),
                    onTap: () {
                      Get.to(() => PatientDetailPage(patient: patient));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
