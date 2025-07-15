import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientSearchAndEditPage extends StatelessWidget {
  const PatientSearchAndEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiController = Get.put(ApiController());
    final queryController = TextEditingController();
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;

    Widget searchPanel() {
      return Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search Patient',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: queryController,
              decoration: const InputDecoration(
                  labelText: 'Name or Phone', contentPadding: EdgeInsets.all(8)),
              onSubmitted: (val) => apiController.searchPatient(val),
            ),
            ElevatedButton(
              onPressed: () => apiController.searchPatient(queryController.text),
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
                        apiController.selectedPatient.value = patient;
                        apiController.nameCtrl.text = patient['name'] ?? '';
                        apiController.ageCtrl.text =
                            '${patient['age'] ?? ''}';
                        apiController.genderCtrl.text =
                            patient['gender'] ?? '';
                        apiController.phoneCtrl.text =
                            patient['phone'] ?? '';
                        apiController.addressCtrl.text =
                            patient['address']?['address'] ?? '';
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

    Widget patientEditor() {
      return Expanded(
        flex: 2,
        child: Obx(() {
          final patient = apiController.selectedPatient.value;
          if (patient == null) {
            return const Center(
              child: Text('Select a patient to view/edit details.'),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Patient Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('OP Number: ${patient['op_number']}',
                      style: const TextStyle(color: Colors.grey)),
                  TextField(
                      controller: apiController.nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name')),
                  TextField(
                      controller: apiController.ageCtrl,
                      decoration: const InputDecoration(labelText: 'Age')),
                  TextField(
                      controller: apiController.genderCtrl,
                      decoration: const InputDecoration(labelText: 'Gender')),
                  TextField(
                      controller: apiController.phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone')),
                  TextField(
                      controller: apiController.addressCtrl,
                      decoration: const InputDecoration(labelText: 'Address')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedData = {
                        'name': apiController.nameCtrl.text,
                        'age': int.tryParse(apiController.ageCtrl.text) ?? 0,
                        'gender': apiController.genderCtrl.text,
                        'phone': apiController.phoneCtrl.text,
                        'address': {
                          'address': apiController.addressCtrl.text,
                        },
                      };
                      await apiController.updatePatient(
                          patient['id'], updatedData);
                      apiController.selectedPatient.value = null;
                    },
                    child: const Text('Update Patient'),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Search & Edit')),
      body: isWideScreen
          ? Row(
              children: [
                searchPanel(),
                const VerticalDivider(width: 1),
                patientEditor(),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 1, child: searchPanel()),
                const Divider(height: 1),
                Expanded(flex: 2, child: patientEditor()),
              ],
            ),
    );
  }
}
