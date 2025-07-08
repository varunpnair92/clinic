import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'edit_visit.dart';

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final api = Get.put(ApiController());
    final queryController = TextEditingController();
    final remarksController = TextEditingController();
    final prescriptionController = TextEditingController();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Doctor Panel")),
            ListTile(
              title: const Text("Reports"),
              onTap: () => Get.toNamed('/reports'),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Left: Search
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: queryController,
                    decoration: const InputDecoration(labelText: 'Name / Phone / OP'),
                    onChanged: (val) => api.searchPatient(val),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() => ListView.builder(
                          itemCount: api.searchResults.length,
                          itemBuilder: (_, index) {
                            final p = api.searchResults[index];
                            return ListTile(
                              title: Text(p['name'] ?? 'Unknown'),
                              subtitle: Text(p['phone'] ?? 'N/A'),
                              onTap: () => api.selectedPatient.value = p,
                            );
                          },
                        )),
                  )
                ],
              ),
            ),
          ),

          // Middle: Patient Info
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final patient = api.selectedPatient.value;
                if (patient == null) {
                  return const Center(child: Text("No Patient Selected"));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patient Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text("Name: ${patient['name'] ?? 'N/A'}"),
                    Text("Age: ${patient['age'] ?? 'N/A'}"),
                    Text("Gender: ${patient['gender'] ?? 'N/A'}"),
                    Text("Phone: ${patient['phone'] ?? 'N/A'}"),
                    Text("Address: ${patient['address']?['address'] ?? 'N/A'}"),
                  ],
                );
              }),
            ),
          ),

          // Right: Visit History + Add Visit
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final patient = api.selectedPatient.value;
                if (patient == null) return const SizedBox();

                final visits = patient['visits'] ?? [];
                final allVisitText = visits.map((visit) {
                  final prescriptions = visit['prescriptions'] ?? [];
                  final reason = visit['reason'] ?? '';
                  final prescriptionText = prescriptions
                      .map((p) => '💊 ${p['medicine_name']} - ${p['instructions']}')
                      .join("\n");
                  return '$reason\n$prescriptionText';
                }).join("\n\n");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Visit History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SingleChildScrollView(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              allVisitText,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: remarksController,
                      decoration: const InputDecoration(labelText: 'Remarks'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: prescriptionController,
                      decoration: const InputDecoration(labelText: 'Prescription'),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await api.addVisit(
                          patientId: patient['id'],
                          reason: remarksController.text,
                          prescription: prescriptionController.text,
                        );
                        await api.searchPatient(patient['name']);
                        api.selectedPatient.value = api.searchResults
                            .firstWhere((p) => p['id'] == patient['id']);
                        remarksController.clear();
                        prescriptionController.clear();
                      },
                      child: const Text("Add Visit"),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
