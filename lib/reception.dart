import 'package:clinic/center_page.dart';
import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReceptionPage extends StatelessWidget {
  const ReceptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiController = Get.put(ApiController());
    final queryController = TextEditingController();
    return CenteredPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Reception Desk', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: queryController,
            decoration: const InputDecoration(
              labelText: 'Search by name or phone',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (val) => apiController.searchPatient(val),
          ),
          const SizedBox(height: 20),
          Obx(() => apiController.loading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: apiController.searchResults.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final p = apiController.searchResults[i];
                    return ListTile(
                      title: Text(p['name']),
                      subtitle: Text("Age: \${p['age']}, Gender: \${p['gender']}\nPhone: \${p['address']['phone']}\n\${p['address']['address']}"),
                      isThreeLine: true,
                    );
                  },
                )),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => Get.toNamed('/register'), child: const Text("Register New Patient")),
        ],
      ),
    );
  }
}
