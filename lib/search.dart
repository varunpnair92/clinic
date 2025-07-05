import 'package:clinic/center_page.dart';
import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final queryController = TextEditingController();
    final apiController = Get.put(ApiController());
    return CenteredPage(
      child: Column(
        children: [
          const Text('Search Patient', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: queryController,
            decoration: const InputDecoration(labelText: 'Name or Phone'),
            onChanged: (val) => apiController.searchPatient(val),
          ),
          const SizedBox(height: 10),
          Obx(() => apiController.loading.value
              ? const CircularProgressIndicator()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: apiController.searchResults.length,
                  itemBuilder: (context, index) {
                    final patient = apiController.searchResults[index];
                    return ListTile(
                      title: Text(patient['name']),
                      subtitle: Text("Age: ${patient['age']}, Gender: ${patient['gender']}"),
                    );
                  },
                )),
        ],
      ),
    );
  }
}