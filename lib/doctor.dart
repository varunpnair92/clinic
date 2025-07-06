import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart'; // Import your ApiController
import 'edit_visit.dart'; // Import your EditVisitPage

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final api = Get.put(ApiController()); // Initialize ApiController
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
            flex:1,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Search',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: queryController,
                  decoration: const InputDecoration(labelText: 'Name or Phone'),
                  onChanged: (val) => api.searchPatient(val),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() => ListView.builder(
                        itemCount: api.searchResults.length,
                        itemBuilder: (_, index) {
                          final p = api.searchResults[index];
                          final phone = p['phone'] ?? 'N/A';
                          return ListTile(
                            title: Text(p['name'] ?? 'Unknown'),
                            subtitle: Text(phone),
                            onTap: () => api.selectedPatient.value = p,
                          );
                        },
                      )),
                )
              ],
            ),
          ),

          // Middle: Patient Info
          Expanded(
            flex:1,
            child: Obx(() {
              final patient = api.selectedPatient.value;
              if (patient == null) return const Center(child: Text("No Patient Selected"));

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Patient Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Name: ${patient['name'] ?? 'N/A'}"),
                    Text("Age: ${patient['age'] ?? 'N/A'}"),
                    Text("Gender: ${patient['gender'] ?? 'N/A'}"),
                    Text("Phone: ${patient['phone'] ?? 'N/A'}"),
                    Text("Address: ${patient['address']?['address'] ?? 'N/A'}"),
                  ],
                ),
              );
            }),
          ),

          // Right: Visit History + Add Visit
          Expanded(
            flex:3,
            child: Obx(() {
              final patient = api.selectedPatient.value;
              if (patient == null) return const SizedBox();

              final visits = patient['visits'] ?? [];

              final allVisitText = visits.map((visit) {
                final prescriptions = visit['prescriptions'] ?? [];
                final reason = visit['reason'] ?? '';
                final prescriptionText = prescriptions.map((p) => '💊 **${p['medicine_name']}** - ${p['instructions']}').join("\n");
                return '$reason\n$prescriptionText';
              }).join("\n\n");

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Visit History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            allVisitText,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    TextField(
                      controller: remarksController,
                      decoration: const InputDecoration(labelText: 'Remarks'),
                    ),
                    TextField(
                      controller: prescriptionController,
                      decoration: const InputDecoration(labelText: 'Prescription'),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await api.addVisit(
                          patientId: patient['id'],
                          reason: remarksController.text,
                          prescription: prescriptionController.text,
                        );
                        await api.searchPatient(patient['name']); // Refresh patient data
                        api.selectedPatient.value = api.searchResults.firstWhere((p) => p['id'] == patient['id']);
                        remarksController.clear();
                        prescriptionController.clear();
                      },
                      child: const Text("Add Visit"),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
